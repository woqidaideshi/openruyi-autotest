#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
QEMU 虚拟机守护服务 (QEMU Daemon)

功能：
  1. 通过 CloudPods API 创建 KVM 虚拟机，在其中启动 openRuyi riscv64 QEMU
  2. 持续监控所有虚拟机的 SSH 可达性
  3. 发现不可达时：等待重试 → 仍不可达则删除并重建
  4. 始终保持 env.json 中有 N 个健康的虚拟机

用法：
  python qemu_daemon.py                  # 使用默认配置启动守护进程
  python qemu_daemon.py --once           # 只初始化一次，不进入守护循环

所有配置项均可通过大写环境变量覆盖，例如：
  TARGET_VM_COUNT=3 python qemu_daemon.py
"""

import os
import sys
import json
import time
import socket
import signal
import logging
import argparse
import threading
import urllib3
import paramiko
import requests
from typing import List, Dict, Any, Optional
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor, as_completed

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# ============================================================
# 日志配置
# ============================================================
log = logging.getLogger("qemu_daemon")
log.setLevel(logging.INFO)
formatter = logging.Formatter(
    fmt="%(asctime)s | %(levelname)-5s | %(threadName)-16s | %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S"
)
console_handler = logging.StreamHandler()
console_handler.setFormatter(formatter)
log.addHandler(console_handler)


# ============================================================
# 工具函数
# ============================================================
def _env(varname: str, default):
    """读取环境变量并自动转换为与 default 相同的类型"""
    val = os.environ.get(varname)
    if val is None:
        return default
    if isinstance(default, bool):
        return val.lower() in ("yes", "true", "1")
    if isinstance(default, int):
        return int(val)
    if isinstance(default, list):
        return [x.strip() for x in val.split(",") if x.strip()]
    return val


# ============================================================
# CloudPods API 客户端
# ============================================================
class CloudPods:
    """CloudPods 云平台 API 客户端"""

    def __init__(self, keystone_url, username, password,
                 domain="default", project="system"):
        self.__keystone_url = keystone_url
        self.__username = username
        self.__password = password
        self.__domain = domain
        self.__project = project
        self.__session = None
        self.__compute_url = None
        self._init_session()

    def _init_session(self):
        """初始化 session 和 endpoint"""
        log.info("初始化 CloudPods session ...")
        session = requests.Session()
        headers = {"User-Agent": "yunioncloud-go/201708"}
        session.headers.update(headers)

        # 获取 token
        url = self.__keystone_url + "/auth/tokens"
        data = {
            "auth": {
                "context": {"source": "cli"},
                "identity": {
                    "methods": ["password"],
                    "password": {
                        "user": {
                            "name": self.__username,
                            "password": self.__password
                        }
                    }
                },
                "scope": {
                    "project": {
                        "domain": {"name": self.__domain},
                        "name": self.__project
                    }
                }
            }
        }
        try:
            rs = session.post(url=url, json=data, verify=False, timeout=600)
            if rs.status_code not in (200, 201):
                raise RuntimeError(f"获取 token 失败: {rs.status_code} {rs.text[:200]}")
            token = rs.headers.get("X-Subject-Token", "")
            if not token:
                raise RuntimeError("未找到 X-Subject-Token")
            headers["X-Auth-Token"] = token
            session.headers.update(headers)
            self.__session = session
        except Exception as e:
            log.error(f"Session 初始化失败: {e}")
            raise

        # 获取 endpoint
        try:
            url = self.__keystone_url + "/endpoints"
            rs = self.__session.get(url=url, verify=False, timeout=600)
            if rs.status_code != 200:
                raise RuntimeError(f"获取 endpoint 失败: {rs.status_code}")
            endpoints = {}
            for elem in rs.json().get("endpoints", []):
                name = elem.get("service_name", "")
                url_val = elem.get("url", "")
                if name and url_val and name not in endpoints:
                    endpoints[name] = url_val
            region_key = next(
                (k for k in endpoints if "region" in k.lower()), "region2"
            )
            if region_key not in endpoints:
                region_key = list(endpoints.keys())[0] if endpoints else "region2"
            self.__compute_url = f"{endpoints[region_key]}/"
            log.info(f"Session 初始化成功, compute_url={self.__compute_url}")
        except Exception as e:
            log.error(f"Endpoint 获取失败: {e}")
            raise

    def refresh_session(self):
        """刷新 session（token 过期时调用）"""
        log.info("刷新 CloudPods session ...")
        try:
            if self.__session:
                self.__session.close()
        except Exception:
            pass
        self._init_session()

    def _request(self, method, path, **kwargs):
        """带自动重试的 API 请求"""
        url = self.__compute_url + path
        for attempt in range(3):
            try:
                rs = self.__session.request(
                    method, url=url, verify=False, timeout=kwargs.pop("timeout", 600), **kwargs
                )
                if rs.status_code == 401:
                    self.refresh_session()
                    continue
                return rs
            except requests.ConnectionError:
                if attempt < 2:
                    time.sleep(5)
                    continue
                raise
        return self.__session.request(
            method, url=url, verify=False, timeout=600, **kwargs
        )

    def create_server(self, kvm_config, vm_name, count=1) -> List[str]:
        """创建 KVM 虚拟机，返回 server_id 列表"""
        log.info(f"创建 CloudPods KVM: {vm_name} x{count} ...")
        nets = [{"network": nid} for nid in kvm_config["network_ids"][:kvm_config["network_count"]]]

        server_config = {
            "auto_start": True,
            "generate_name": vm_name,
            "hypervisor": "kvm",
            "disable_delete": False,
            "__count__": count,
            "deploy_telegraf": True,
            "os_arch": kvm_config["cpu_arch"],
            "nets": nets,
            "prefer_region": "default",
            "bios": kvm_config["bios_mode"].upper(),
            "guest_image_id": kvm_config["guest_image_id"],
            "sku": kvm_config["instance_type"],
            "password": kvm_config["kvm_ssh_password"],
            "disks": [{
                "disk_type": "sys",
                "index": 0,
                "backend": "local",
                "size": kvm_config["system_disk_size_mb"],
                "image_id": kvm_config["disk_image_id"],
                "medium": "ssd"
            }]
        }
        for i, gb in enumerate(kvm_config["data_disk_sizes_gb"]):
            server_config["disks"].append({
                "disk_type": "data",
                "index": i + 1,
                "backend": "local",
                "size": gb * 1024,
                "medium": "ssd"
            })

        rs = self._request("POST", "servers", json={"count": count, "server": server_config})
        if rs.status_code != 200:
            log.error(f"创建服务器失败: {rs.status_code} {rs.text[:500]}")
            return []
        data = rs.json()
        server_ids = []
        # 多种可能的响应格式：server/servers/data
        server_data = data.get("server") or data.get("servers") or data.get("data")
        if isinstance(server_data, dict):
            sid = server_data.get("id")
            if sid:
                server_ids.append(sid)
        elif isinstance(server_data, list):
            for s in server_data:
                sid = s.get("id", "") if isinstance(s, dict) else str(s)
                if sid:
                    server_ids.append(sid)
        log.info(f"创建成功, IDs: {server_ids}")
        return server_ids

    def get_server_ip(self, server_id) -> Optional[str]:
        rs = self._request("GET", f"servers/{server_id}")
        if rs.status_code != 200:
            return None
        server = rs.json().get("server", rs.json())
        nics = server.get("nics", [])
        return nics[0].get("ip_addr") if nics else None

    def get_server_status(self, server_id) -> Optional[str]:
        try:
            rs = self._request("GET", f"servers/{server_id}/status")
            if rs.status_code != 200:
                return None
            return rs.json().get("server", {}).get("status")
        except Exception:
            return None

    def delete_server(self, server_id) -> bool:
        """删除 CloudPods KVM 虚拟机"""
        log.info(f"删除 CloudPods 服务器: {server_id} ...")
        try:
            rs = self._request("DELETE", f"servers/{server_id}")
            if rs.status_code in (200, 204, 404):
                log.info(f"服务器 {server_id} 已删除（或不存在）")
                return True
            log.warning(f"删除服务器返回: {rs.status_code}")
            return False
        except Exception as e:
            log.error(f"删除服务器异常: {e}")
            return False

    def wait_for_server_running(self, server_id, timeout=1800) -> bool:
        log.info(f"等待服务器 {server_id} running ...")
        elapsed = 0
        running_streak = 0
        while elapsed < timeout:
            status = self.get_server_status(server_id)
            if status is None:
                time.sleep(5)
                elapsed += 5
                continue
            if status == "running":
                running_streak += 1
                if running_streak >= 5:
                    self._modify_src_check(server_id)
                    log.info(f"服务器 {server_id} running（稳定）")
                    return True
                time.sleep(1)
                elapsed += 1
            elif "_fail" in status or status in ("ready", "disk_fail"):
                log.error(f"服务器 {server_id} 状态异常: {status}")
                return False
            else:
                running_streak = 0
                time.sleep(5)
                elapsed += 5
        log.error(f"等待服务器 {server_id} running 超时")
        return False

    def _modify_src_check(self, server_id):
        try:
            url = f"servers/{server_id}/modify-src-check"
            data = {"server": {"src_ip_check": "off", "src_mac_check": "off"}}
            self._request("POST", url, json=data)
        except Exception as e:
            log.warning(f"modify_src_check 异常: {e}")


# ============================================================
# SSH 客户端
# ============================================================
class SSHClient:
    """轻量 SSH 客户端"""

    def __init__(self, host, port=22, username="root", password="",
                 connect_timeout=15):
        self.host = host
        self.port = port
        self._ssh = paramiko.SSHClient()
        self._ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        self._ssh.connect(
            host, port=port,
            username=username, password=password,
            look_for_keys=False, allow_agent=False,
            timeout=connect_timeout,
            banner_timeout=connect_timeout,
            auth_timeout=connect_timeout
        )

    def exec(self, cmd, timeout=300):
        stdin, stdout, stderr = self._ssh.exec_command(cmd, timeout=timeout)
        exit_code = stdout.channel.recv_exit_status()
        out = stdout.read().decode("utf-8", errors="replace").strip()
        err = stderr.read().decode("utf-8", errors="replace").strip()
        return out, err, exit_code

    def close(self):
        try:
            self._ssh.close()
        except Exception:
            pass

    @staticmethod
    def check_port(host, port, timeout=5) -> bool:
        """检测端口是否可达"""
        try:
            sock = socket.create_connection((host, port), timeout=timeout)
            sock.close()
            return True
        except (socket.timeout, ConnectionRefusedError, OSError):
            return False


# ============================================================
# QEMU 虚拟机管理器
# ============================================================
class QemuVMManager:
    """在 CloudPods KVM 内部管理 QEMU 虚拟机"""

    def __init__(self, kvm_ip, cfg):
        self.kvm_ip = kvm_ip
        self.cfg = cfg
        self.qemu_port = cfg["qemu_ssh_port"]
        self._ssh: Optional[SSHClient] = None

    def connect(self) -> bool:
        """SSH 连接 KVM 宿主机"""
        ks = self.cfg
        for i in range(12):
            try:
                self._ssh = SSHClient(
                    self.kvm_ip,
                    port=ks["kvm_ssh_port"],
                    username=ks["kvm_ssh_user"],
                    password=ks["kvm_ssh_password"]
                )
                log.info(f"[{self.kvm_ip}] SSH 连接 KVM 成功")
                return True
            except Exception as e:
                log.warning(f"[{self.kvm_ip}] SSH 连接失败 ({i + 1}/12): {e}")
                time.sleep(10)
        return False

    def setup(self) -> bool:
        """完整设置：YUM 仓库 → 安装依赖 → 下载镜像 → 启动 QEMU → 等待就绪"""
        log.info(f"[{self.kvm_ip}] 开始设置 QEMU 环境 ...")

        cfg = self.cfg
        work_dir = "/opt/openruyi_qemu"

        # 1. 配置 YUM 仓库
        log.info(f"[{self.kvm_ip}] 配置 YUM 仓库 ...")
        if cfg["delete_default_yum_repos"]:
            self._ssh.exec(
                "mkdir -p /etc/yum.repos.d/backup && "
                "mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup/ 2>/dev/null; "
                "echo done"
            )
        self._ssh.exec(
            f"cat > /etc/yum.repos.d/openruyi.repo << 'EOF'\n"
            f"[openruyi]\n"
            f"name=openRuyi\n"
            f"baseurl={cfg['yum_repo_baseurl']}\n"
            f"enabled=1\n"
            f"gpgcheck=0\n"
            f"EOF"
        )

        # 2. 安装依赖
        log.info(f"[{self.kvm_ip}] 安装 QEMU 及依赖 ...")
        for cmd in [
            "dnf install -y qemu-system-riscv openssh-clients wget xz "
            "nmap-ncat qemu-img --nogpgcheck --skip-broken",
            "which qemu-system-riscv64 || "
            "dnf install -y qemu-system-riscv-core --nogpgcheck --skip-broken",
        ]:
            out, err, rc = self._ssh.exec(cmd, timeout=600)
            if rc != 0:
                log.warning(f"[{self.kvm_ip}] 安装命令 exit={rc}: {cmd[:60]}...")

        # 3. 下载 QEMU 镜像和固件
        log.info(f"[{self.kvm_ip}] 下载 QEMU 镜像和固件 ...")
        self._ssh.exec(f"mkdir -p {work_dir}")
        for fname, url in [
            ("RISCV_VIRT_CODE.fd", cfg["qemu_uefi_code_url"]),
            ("RISCV_VIRT_VARS.fd", cfg["qemu_uefi_vars_url"]),
        ]:
            self._ssh.exec(
                f"if [ ! -f {work_dir}/{fname} ]; then "
                f"wget -q -O {work_dir}/{fname} '{url}'; fi",
                timeout=300
            )

        img = f"{work_dir}/openruyi-virt_riscv64.qcow2"
        xz = f"{work_dir}/openruyi-virt_riscv64.qcow2.xz"
        out, err, rc = self._ssh.exec(
            f"if [ ! -f {img} ]; then "
            f"  wget -q -O {xz} '{cfg['qemu_system_image_url']}' && "
            f"  xz -d {xz}; "
            f"fi && echo 'IMAGE_READY'",
            timeout=1800
        )
        if rc != 0 or "IMAGE_READY" not in out:
            log.error(f"[{self.kvm_ip}] 下载镜像失败")
            return False
        log.info(f"[{self.kvm_ip}] 镜像就绪")

        # 4. 启动 QEMU
        log.info(f"[{self.kvm_ip}] 启动 QEMU 虚拟机 ...")
        qemu_script = f"{work_dir}/start_qemu.sh"
        self._ssh.exec(
            f"cat > {qemu_script} << 'QEMU_EOF'\n"
            f"#!/bin/bash\nset -e\ncd {work_dir}\n"
            f"cp RISCV_VIRT_VARS.fd RISCV_VIRT_VARS_LIVE.fd\n"
            f"qemu-system-riscv64 \\\n"
            f"  -nographic \\\n"
            f"  -machine virt \\\n"
            f"  -smp {cfg['qemu_cpu_cores']} \\\n"
            f"  -m {cfg['qemu_memory']} \\\n"
            f"  -bios RISCV_VIRT_CODE.fd \\\n"
            f"  -drive file=openruyi-virt_riscv64.qcow2,format=qcow2,id=hd0 \\\n"
            f"  -device virtio-blk-device,drive=hd0 \\\n"
            f"  -netdev user,id=net0,hostfwd=tcp::{self.qemu_port}-:22 \\\n"
            f"  -device virtio-net-device,netdev=net0 \\\n"
            f"  -object rng-random,filename=/dev/urandom,id=rng0 \\\n"
            f"  -device virtio-rng-device,rng=rng0\n"
            f"QEMU_EOF\n"
            f"chmod +x {qemu_script}"
        )
        self._ssh.exec(f"fuser -k {self.qemu_port}/tcp 2>/dev/null; sleep 1; echo done")
        self._ssh.exec(f"nohup bash {qemu_script} > {work_dir}/qemu.log 2>&1 &")
        log.info(f"[{self.kvm_ip}] QEMU 已后台启动")

        # 5. 等待 QEMU 端口可达
        log.info(f"[{self.kvm_ip}] 等待 QEMU SSH :{self.qemu_port} 可达 ...")
        timeout = cfg["qemu_boot_timeout"]
        for i in range(0, timeout, 10):
            out, err, rc = self._ssh.exec(
                f"nc -z 127.0.0.1 {self.qemu_port} && echo OPEN || echo CLOSED",
                timeout=15
            )
            if "OPEN" in out:
                log.info(f"[{self.kvm_ip}] QEMU VM 端口可达！")
                time.sleep(10)  # 让 SSH 服务完全就绪
                return True
            if i % 60 == 0 and i > 0:
                log.info(f"[{self.kvm_ip}] 等待 QEMU boot ({i}s/{timeout}s) ...")
            time.sleep(10)

        log.error(f"[{self.kvm_ip}] QEMU 启动超时")
        return False

    def is_qemu_sshable(self) -> bool:
        """检查 QEMU VM 是否可通过 SSH 连接"""
        if not self._ssh:
            return False
        try:
            out, err, rc = self._ssh.exec(
                f"nc -z 127.0.0.1 {self.qemu_port} && echo OPEN || echo CLOSED",
                timeout=10
            )
            return "OPEN" in out
        except Exception:
            return False

    def qemu_ssh_connect_test(self) -> bool:
        """通过 KVM 直接 nc 检查 QEMU SSH 端口"""
        return self.is_qemu_sshable()

    def cleanup(self):
        if self._ssh:
            self._ssh.close()
            self._ssh = None


# ============================================================
# 虚拟机条目
# ============================================================
def make_env_entry(server_id, kvm_ip, cfg) -> dict:
    """构造 env.json 中的单条记录"""
    return {
        "id": server_id,
        "ip": kvm_ip,
        "port": str(cfg["qemu_ssh_port"]),
        "user": cfg["qemu_ssh_user"],
        "password": cfg["qemu_ssh_password"],
        "type": "kvm",
        "provider": "cloudpods",
        "sshable": True,
        "os_version": "openRuyi",
        "arch": cfg["cpu_arch"],
    }


# ============================================================
# 虚拟机配置
# ============================================================
def provision_one(cloudpods: CloudPods, index: int, cfg: dict) -> Optional[dict]:
    """
    创建一台完整的虚拟机（CloudPods KVM + QEMU）
    返回 env.json 条目，失败返回 None
    """
    vm_name = f"{cfg['vm_name_prefix']}-{index}"
    log.info(f"[{index}] ========== 开始创建 {vm_name} ==========")

    # 1. 创建 CloudPods KVM
    server_ids = cloudpods.create_server(cfg, vm_name, count=1)
    if not server_ids:
        log.error(f"[{index}] CloudPods 创建失败")
        return None
    server_id = server_ids[0]
    log.info(f"[{index}] Server ID: {server_id}")

    # 2. 等待 KVM running
    if not cloudpods.wait_for_server_running(server_id, timeout=cfg["cloudpods_server_create_timeout"]):
        log.error(f"[{index}] KVM 启动超时，删除 ...")
        cloudpods.delete_server(server_id)
        return None

    log.info(f"[{index}] 等待 cloud-init 完成 ...")
    time.sleep(60)

    # 3. 获取 IP
    kvm_ip = cloudpods.get_server_ip(server_id)
    if not kvm_ip:
        log.error(f"[{index}] 无法获取 KVM IP，删除 ...")
        cloudpods.delete_server(server_id)
        return None
    log.info(f"[{index}] KVM IP: {kvm_ip}")

    # 4. SSH 连接 KVM 并设置 QEMU
    manager = QemuVMManager(kvm_ip, cfg)
    try:
        if not manager.connect():
            log.error(f"[{index}] 无法 SSH 连接 KVM，删除 ...")
            cloudpods.delete_server(server_id)
            return None
        if not manager.setup():
            log.error(f"[{index}] QEMU 设置失败，删除 KVM ...")
            cloudpods.delete_server(server_id)
            return None
        log.info(f"[{index}] QEMU VM 启动成功！")
    finally:
        manager.cleanup()

    entry = make_env_entry(server_id, kvm_ip, cfg)
    log.info(f"[{index}] 完成! id={server_id}, ip={kvm_ip}")
    return entry


# ============================================================
# 虚拟机健康检查
# ============================================================
def check_vm_healthy(entry: dict, retries: int = 3, retry_delay: int = 10) -> bool:
    """检查 env.json 中的虚拟机是否可通过 SSH 连接，支持内部重试"""
    host = entry.get("ip", "")
    port = int(entry.get("port", 22))
    user = entry.get("user", "root")
    password = entry.get("password", "")

    if not host:
        return False

    for attempt in range(retries):
        # 先用端口检测快速判断
        if not SSHClient.check_port(host, port, timeout=5):
            if attempt < retries - 1:
                log.debug(f"[{host}:{port}] 端口不可达，{retry_delay}s 后重试 ({attempt+1}/{retries})")
                time.sleep(retry_delay)
                continue
            log.warning(f"[{host}:{port}] 端口不可达（{retries}次尝试）")
            return False

        # 再用 SSH 连接验证
        try:
            ssh = SSHClient(host, port=port, username=user, password=password,
                            connect_timeout=10)
            out, err, rc = ssh.exec("echo ALIVE", timeout=10)
            ssh.close()
            if rc == 0 and "ALIVE" in out:
                return True
        except Exception as e:
            pass  # 重试

        if attempt < retries - 1:
            log.debug(f"[{host}:{port}] SSH 检查失败，{retry_delay}s 后重试 ({attempt+1}/{retries})")
            time.sleep(retry_delay)

    log.warning(f"[{host}:{port}] SSH 检查失败（{retries}次尝试）")
    return False


# ============================================================
# QEMU 守护服务
# ============================================================
class QemuDaemon:
    """QEMU 虚拟机守护服务：持续维护 N 个可 SSH 的虚拟机"""

    def __init__(self, cfg: dict):
        self.cfg = cfg
        self.target_count = cfg["target_vm_count"]
        self.env_json_path = self._resolve_env_path(cfg["env_json_path"])
        self._running = threading.Event()
        self._running.set()
        self._next_index_lock = threading.Lock()
        self._next_index = 1
        self._cloudpods: Optional[CloudPods] = None

    @staticmethod
    def _resolve_env_path(path: str) -> str:
        """解析 env.json 路径"""
        p = Path(path)
        if not p.is_absolute():
            p = Path(__file__).resolve().parent / p
        return str(p)

    def _alloc_index(self) -> int:
        """分配下一个可用的虚拟机编号"""
        with self._next_index_lock:
            idx = self._next_index
            self._next_index += 1
            return idx

    def _init_cloudpods(self) -> CloudPods:
        """初始化 CloudPods 客户端"""
        return CloudPods(
            self.cfg["cloudpods_keystone_url"],
            self.cfg["cloudpods_admin_user"],
            self.cfg["cloudpods_admin_password"],
        )

    def _load_env(self) -> List[dict]:
        """加载 env.json"""
        try:
            with open(self.env_json_path, "r", encoding="utf-8") as f:
                data = json.load(f)
            return data.get("env", [])
        except (FileNotFoundError, json.JSONDecodeError):
            return []

    def _save_env(self, entries: List[dict]):
        """保存 env.json"""
        os.makedirs(os.path.dirname(self.env_json_path) or ".", exist_ok=True)
        with open(self.env_json_path, "w", encoding="utf-8") as f:
            json.dump({"env": entries}, f, indent=4, ensure_ascii=False)
        log.info(f"env.json 已更新: {len(entries)} 台虚拟机")

    def run(self, once=False):
        """主循环"""
        log.info(f"QEMU 守护服务启动，目标虚拟机数: {self.target_count}")
        log.info(f"env.json 路径: {self.env_json_path}")

        self._cloudpods = self._init_cloudpods()
        cloudpods = self._cloudpods

        # 初始填充到目标数量
        self._fill_to_target(cloudpods)

        if once:
            log.info("--once 模式，初始化完成，退出")
            return

        # 守护循环
        log.info(f"进入守护模式，健康检查间隔: {self.cfg['health_check_interval']}s")
        cycle = 0
        while self._running.is_set():
            cycle += 1
            log.info(f"========== 健康检查周期 #{cycle} ==========")
            self._health_check_cycle(cloudpods)
            log.info(f"周期 #{cycle} 完成，等待 {self.cfg['health_check_interval']}s ...")
            self._running.wait(self.cfg["health_check_interval"])

    def _fill_to_target(self, cloudpods: CloudPods):
        """确保 env.json 有 target_count 个健康的虚拟机（仅管理 cloudpods 条目）"""
        entries = self._load_env()

        # 区分 CloudPods 条目和其他条目
        cloudpods_entries = [e for e in entries if e.get("provider") == "cloudpods"]
        other_entries = [e for e in entries if e.get("provider") != "cloudpods"]

        # 对 CloudPods 条目做健康检查，不健康则重试后删除
        healthy = []
        for e in cloudpods_entries:
            if check_vm_healthy(e):
                healthy.append(e)
            else:
                log.warning(f"初始检查: {e.get('ip')}:{e.get('port')} 不可达，等待 {self.cfg['unhealthy_retry_wait']}s 后重试 ...")
                time.sleep(self.cfg["unhealthy_retry_wait"])
                if check_vm_healthy(e):
                    healthy.append(e)
                    log.info(f"{e.get('ip')}:{e.get('port')} 重试后恢复")
                else:
                    log.warning(f"确认不可达，删除 CloudPods 资源: {e.get('id')}")
                    cloudpods.delete_server(e.get("id", ""))

        self._save_env(healthy + other_entries)
        missing = self.target_count - len(healthy)
        if missing <= 0:
            log.info(f"已有 {len(healthy)} 台健康 CloudPods 虚拟机，无需补充")
            return

        log.info(f"需要补充 {missing} 台 CloudPods 虚拟机")
        self._provision_vms(cloudpods, missing)

    def _health_check_cycle(self, cloudpods: CloudPods):
        """执行一轮健康检查并修复（仅管理 cloudpods 条目）"""
        entries = self._load_env()
        cloudpods_entries = [e for e in entries if e.get("provider") == "cloudpods"]
        other_entries = [e for e in entries if e.get("provider") != "cloudpods"]

        dead = []
        alive = []

        for e in cloudpods_entries:
            if check_vm_healthy(e):
                alive.append(e)
            else:
                dead.append(e)

        if not dead:
            log.info(f"所有 {len(alive)} 台 CloudPods 虚拟机健康")
            return

        log.warning(f"发现 {len(dead)} 台 CloudPods 虚拟机不可达，等待 {self.cfg['unhealthy_retry_wait']}s 后重试 ...")
        time.sleep(self.cfg["unhealthy_retry_wait"])

        # 重试
        still_dead = []
        for e in dead:
            if check_vm_healthy(e):
                alive.append(e)
                log.info(f"{e.get('ip')}:{e.get('port')} 重试后恢复")
            else:
                still_dead.append(e)

        if still_dead:
            log.warning(f"确认 {len(still_dead)} 台 CloudPods 虚拟机不可达，开始删除并重建 ...")
            for e in still_dead:
                log.info(f"删除 CloudPods 服务器: {e.get('id')}")
                cloudpods.delete_server(e.get("id", ""))

            self._save_env(alive + other_entries)
            missing = self.target_count - len(alive)
            self._provision_vms(cloudpods, missing)
        else:
            self._save_env(alive + other_entries)

    def _provision_vms(self, cloudpods: CloudPods, count: int):
        """并行创建 count 台虚拟机"""
        max_workers = min(self.cfg["max_parallel_provision"], count)
        results = list(self._load_env())

        with ThreadPoolExecutor(max_workers=max_workers, thread_name_prefix="Prov") as executor:
            futures = {}
            for _ in range(count):
                idx = self._alloc_index()
                futures[executor.submit(provision_one, cloudpods, idx, self.cfg)] = idx

            for future in as_completed(futures):
                idx = futures[future]
                try:
                    entry = future.result(timeout=3600)
                    if entry:
                        results.append(entry)
                        self._save_env(results)
                        log.info(f"[{idx}] 虚拟机就绪并写入 env.json")
                    else:
                        log.error(f"[{idx}] 虚拟机创建失败")
                except Exception as e:
                    log.error(f"[{idx}] 异常: {e}")

    def shutdown(self):
        """优雅关闭 - 删除所有通过 CloudPods 创建的虚拟机，保留其他条目"""
        log.info("收到关闭信号，退出守护循环 ...")
        self._running.clear()

        # 读取 env.json 中所有虚拟机
        entries = self._load_env()
        if not entries:
            log.info("env.json 中无虚拟机记录，跳过清理")
            return

        # 区分 CloudPods 创建的和其他的
        cloudpods_entries = [e for e in entries if e.get("provider") == "cloudpods"]
        other_entries = [e for e in entries if e.get("provider") != "cloudpods"]

        if not cloudpods_entries:
            log.info("env.json 中无 CloudPods 创建的虚拟机，跳过清理")
            return

        log.info(f"开始清理 CloudPods 上的 {len(cloudpods_entries)} 台虚拟机 ...")
        cloudpods = self._cloudpods or self._init_cloudpods()

        for e in cloudpods_entries:
            sid = e.get("id", "")
            ip = e.get("ip", "?")
            log.info(f"删除 CloudPods 服务器: id={sid}, ip={ip}")
            cloudpods.delete_server(sid)

        # 只保留非 CloudPods 条目
        self._save_env(other_entries)
        log.info(f"CloudPods 虚拟机已清理完毕，保留 {len(other_entries)} 条其他记录")


# ============================================================
# 主函数
# ============================================================
def main(defaults: dict):
    """主入口 - defaults 为默认配置字典，实际值可通过同名大写环境变量覆盖"""

    # 用环境变量覆盖默认值
    cfg = {}
    for key, default_val in defaults.items():
        cfg[key] = _env(key.upper(), default_val)

    # ========== 命令行参数 ==========
    parser = argparse.ArgumentParser(
        description="QEMU 虚拟机守护服务 - 保持 N 个 openRuyi riscv64 QEMU 始终可 SSH"
    )
    parser.add_argument("--once", action="store_true",
                        help="只初始化一次，不进入守护循环")
    parser.add_argument("--count", "-N", type=int, default=None,
                        help="目标虚拟机数量（覆盖 TARGET_VM_COUNT）")
    args = parser.parse_args()

    if args.count is not None:
        cfg["target_vm_count"] = args.count

    # ========== 启动 ==========
    banner = f"""
{'=' * 60}
  QEMU 虚拟机守护服务
  {'=' * 56}
  目标数量:   {cfg['target_vm_count']}
  命名前缀:   {cfg['vm_name_prefix']}
  env.json:   {cfg['env_json_path']}
  检查间隔:   {cfg['health_check_interval']}s
  重试等待:   {cfg['unhealthy_retry_wait']}s
  QEMU SSH:   {cfg['qemu_ssh_user']}@{cfg['qemu_ssh_port']}
  模式:       {'单次初始化' if args.once else '守护循环'}
{'=' * 60}"""
    print(banner)

    daemon = QemuDaemon(cfg)

    # 处理 SIGINT/SIGTERM
    def _shutdown(signum, frame):
        daemon.shutdown()
    signal.signal(signal.SIGINT, _shutdown)
    signal.signal(signal.SIGTERM, _shutdown)

    daemon.run(once=args.once)
    log.info("守护服务已退出")


if __name__ == "__main__":
    # ========== 默认配置（所有值均可通过同名大写环境变量覆盖）==========
    DEFAULTS: dict = {
        # 目标虚拟机数量（始终保持该数量的 QEMU VM 可 SSH）
        "target_vm_count":          10,

        # 虚拟机命名
        "vm_name_prefix":           "openruyi-redrose2100",

        # CloudPods 平台连接
        "cloudpods_keystone_url":   "https://10.20.40.101:30500/v3",
        "cloudpods_admin_user":     "admin",
        "cloudpods_admin_password": "jSj@2008",

        # CloudPods KVM 虚拟机规格
        "guest_image_id":           "6f59c2c8-73f8-449b-8546-b6cf2b5564a0",
        "disk_image_id":            "40fb8262-0566-4877-8eb0-d991903e9be7",
        "instance_type":            "ecs.g1.c8m16",
        "bios_mode":                "BIOS",
        "cpu_arch":                 "riscv64",
        "system_disk_size_mb":      204800,
        "data_disk_sizes_gb":       [20],
        "network_ids": [
            "efdb73ac-d785-47a1-82bf-65c2229eacca",
            "3e0ac273-6da8-4188-821b-d97a84cb7754",
            "04bc4008-f5a6-40a0-84aa-5fcd76e3f2ef",
            "0f71d7ea-6e7a-42bc-81c3-290e396581a7",
            "b7272573-29ea-4e46-8c27-22b81503aee6",
        ],
        "network_count":            1,

        # KVM 宿主机 SSH 登录
        "kvm_ssh_user":             "root",
        "kvm_ssh_password":         "ISRCpassword@123",
        "kvm_ssh_port":             22,

        # QEMU 镜像下载地址
        "qemu_system_image_url":    "https://s3.develop.oepkgs.net/demo/openruyi-virt_riscv64.qcow2.xz",
        "qemu_uefi_code_url":       "https://s3.develop.oepkgs.net/demo/RISCV_VIRT_CODE.fd",
        "qemu_uefi_vars_url":       "https://s3.develop.oepkgs.net/demo/RISCV_VIRT_VARS.fd",

        # QEMU 虚拟机规格
        "qemu_cpu_cores":           8,
        "qemu_memory":              "8G",

        # QEMU 虚拟机 SSH 登录
        "qemu_ssh_user":            "root",
        "qemu_ssh_password":        "openruyi",
        "qemu_ssh_port":            12055,

        # YUM 仓库
        "delete_default_yum_repos": False,
        "yum_repo_baseurl":         "https://diamond.oerv.ac.cn/openruyi/riscv64/",

        # 超时设置（秒）
        "cloudpods_server_create_timeout": 1800,
        "qemu_boot_timeout":               1800,

        # 守护进程设置
        "health_check_interval":    60,
        "unhealthy_retry_wait":     60,
        "env_json_path":            "env.json",
        "max_parallel_provision":   5,
    }

    main(DEFAULTS)
