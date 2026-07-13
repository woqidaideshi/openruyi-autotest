#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
CloudPods QEMU Launcher Script
基于 mugen-generator 代码库分析，创建一个精简的 CloudPods 虚拟机启动器。

功能：
1. 通过 CloudPods API 创建虚拟机（支持 x86_64 / aarch64 / riscv64）
2. 等待虚拟机就绪（开机 + SSH 可达）
3. 配置 yum 源
4. 准备测试环境（可选：git clone os-autotest 代码）
5. 跳过 os-autotest 下载和测试执行

用法：
    python cloudpods_launcher.py \
        --os-version 24.03-LTS-SP1 \
        --os-arch riscv64 \
        --vm-count 1 \
        --action create \
        --vm-name my-test-vm

环境变量（也可通过 --env 设置）：
    CLOUDPODS_KEYSTONE_URL  - CloudPods Keystone 认证地址
    CLOUDPODS_USER          - CloudPods 用户名
    CLOUDPODS_PASSWORD      - CloudPods 密码
    GUEST_IMAGE_ID          - 自定义 guest 镜像 ID（覆盖内置映射）
    DISK_IMAGE_ID           - 自定义 disk 镜像 ID（覆盖内置映射）
    CLOUDPODS_NET_LIST      - 网络 ID 列表（逗号分隔）
"""

import argparse
import json
import os
import re
import sys
import time
import logging
from typing import List, Dict, Optional, Tuple

# ============================================================
# CloudPods Client (精简版，从 mugen-generator 提取核心逻辑)
# ============================================================

try:
    import requests
    import urllib3
    urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
except ImportError:
    print("ERROR: requests 库未安装，请执行: pip install requests urllib3")
    sys.exit(1)

log = logging.getLogger("cloudpods_launcher")
log.setLevel(logging.DEBUG)
_formatter = logging.Formatter(
    fmt="%(asctime)s | %(levelname)-7s | %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S"
)
_console_handler = logging.StreamHandler()
_console_handler.setFormatter(_formatter)
log.addHandler(_console_handler)


class CloudPodsClient:
    """CloudPods API 客户端（精简版，基于 mugen-generator/cloudpods/cloudpods.py）"""

    def __init__(self, keystone_url: str, username: str, password: str,
                 domain: str = "default", project: str = "system"):
        self._keystone_url = keystone_url
        self._username = username
        self._password = password
        self._domain = domain
        self._project = project
        self._session = requests.Session()
        self._session.headers.update({"User-Agent": "cloudpods-launcher/1.0"})
        self._compute_url = ""

    def authenticate(self) -> bool:
        """获取 Keystone token"""
        url = f"{self._keystone_url}/auth/tokens"
        data = {
            "auth": {
                "context": {"source": "cli"},
                "identity": {
                    "methods": ["password"],
                    "password": {
                        "user": {
                            "name": self._username,
                            "password": self._password
                        }
                    }
                },
                "scope": {
                    "project": {
                        "domain": {"name": self._domain},
                        "name": self._project
                    }
                }
            }
        }
        try:
            resp = self._session.post(url=url, json=data, verify=False, timeout=60)
            if resp.status_code != 201:
                log.error(f"认证失败: HTTP {resp.status_code}, body={resp.text}")
                return False
            token = resp.headers.get("X-Subject-Token", "")
            if not token:
                log.error("认证失败: 未返回 X-Subject-Token")
                return False
            self._session.headers.update({"X-Auth-Token": token})

            # 获取 endpoint
            eps = self._get_endpoints()
            if not eps or "region2" not in eps:
                log.error("获取 endpoint 失败")
                return False
            self._compute_url = f"{eps['region2']}/"
            log.info(f"认证成功, compute_url={self._compute_url}")
            return True
        except Exception as e:
            log.error(f"认证异常: {e}")
            return False

    def _get_endpoints(self) -> Dict[str, str]:
        url = f"{self._keystone_url}/endpoints"
        try:
            resp = self._session.get(url=url, verify=False, timeout=30)
            if resp.status_code != 200:
                log.warning(f"获取 endpoints 失败: {resp.status_code}")
                return {}
            data = resp.json()
            eps = {}
            for ep in data.get("endpoints", []):
                region = ep.get("region", "")
                eps[region] = ep.get("url", "")
            return eps
        except Exception as e:
            log.warning(f"获取 endpoints 异常: {e}")
            return {}

    def _create_server_raw(self, server_config: dict, count: int = 1) -> Optional[dict]:
        url = f"{self._compute_url}servers"
        try:
            resp = self._session.post(url=url, json=server_config, verify=False, timeout=60)
            if resp.status_code >= 400:
                log.error(f"创建服务器失败: HTTP {resp.status_code}, body={resp.text}")
                return None
            return resp.json()
        except Exception as e:
            log.error(f"创建服务器异常: {e}")
            return None

    def create_server(self,
                      guest_image_id: str,
                      disk_image_id: str,
                      arch: str,
                      vm_name: str,
                      disk_size: int = 204800,
                      data_disks: List[int] = None,
                      nets_list: List[str] = None,
                      sku: str = "ecs.g1.c4m12",
                      count: int = 1,
                      hypervisor: str = "kvm",
                      bios: str = "bios") -> List[str]:
        """创建虚拟机，返回 server_id 列表"""
        if data_disks is None:
            data_disks = [20]
        if nets_list is None:
            nets_list = ["e50836ad-cc39-4683-8d6b-072866f1981d"]

        nets = [{"network": net} for net in nets_list]

        server_config = {
            "auto_start": True,
            "generate_name": vm_name,
            "hypervisor": hypervisor,
            "disable_delete": False,
            "__count__": count,
            "deploy_telegraf": True,
            "os_arch": arch,
            "nets": nets,
            "prefer_region": "default",
            "bios": bios,
            "guest_image_id": guest_image_id,
            "sku": sku,
            "reset_password": False,
        }

        # 系统盘 + 数据盘
        disks = [{
            "disk_type": "sys",
            "index": 0,
            "backend": "local",
            "size": disk_size,
            "image_id": disk_image_id,
            "medium": "ssd"
        }]
        for i, ds in enumerate(data_disks):
            disks.append({
                "disk_type": "data",
                "index": i + 1,
                "backend": "local",
                "size": ds * 1024,
                "medium": "ssd"
            })
        server_config["disks"] = disks

        log.info(f"创建服务器: name={vm_name}, arch={arch}, sku={sku}, count={count}")
        result = self._create_server_raw(server_config, count)
        if not result:
            return []

        server_ids = []
        if "server" in result and "id" in result["server"]:
            server_ids.append(result["server"]["id"])
        elif "servers" in result:
            for s in result["servers"]:
                if s and "body" in s and "id" in s["body"]:
                    server_ids.append(s["body"]["id"])
        return server_ids

    def get_server_detail(self, server_id: str) -> Optional[dict]:
        url = f"{self._compute_url}servers/{server_id}"
        try:
            resp = self._session.get(url=url, verify=False, timeout=30)
            if resp.status_code >= 400:
                log.warning(f"获取服务器详情失败: {resp.status_code}")
                return None
            return resp.json()
        except Exception as e:
            log.warning(f"获取服务器详情异常: {e}")
            return None

    def get_server_ip(self, server_id: str, network_id: str = "") -> Optional[str]:
        detail = self.get_server_detail(server_id)
        if not detail or "server" not in detail:
            return None
        server = detail["server"]
        nics = server.get("nics", [])
        if not nics:
            return None
        if not network_id:
            return nics[0].get("ip_addr")
        for nic in nics:
            if nic.get("network_id") == network_id:
                return nic.get("ip_addr")
        return None

    def get_server_status(self, server_id: str) -> str:
        detail = self.get_server_detail(server_id)
        if not detail or "server" not in detail:
            return "unknown"
        return detail["server"].get("status", "unknown")

    def wait_for_server_running(self, server_id: str, timeout: int = 1800) -> bool:
        """等待服务器状态变为 running"""
        log.info(f"等待服务器 {server_id} 就绪 (超时 {timeout}s)...")
        elapsed = 0
        running_checks = 0
        while elapsed < timeout:
            status = self.get_server_status(server_id)
            if "_fail" in status:
                log.error(f"服务器 {server_id} 状态异常: {status}")
                return False
            if status == "running":
                running_checks += 1
                if running_checks >= 5:
                    log.info(f"服务器 {server_id} 已运行 (连续 {running_checks} 次确认)")
                    self._modify_src_check(server_id, "off", "off")
                    return True
            else:
                log.info(f"服务器 {server_id} 状态: {status}")
            time.sleep(10)
            elapsed += 10
        log.error(f"服务器 {server_id} 等待超时")
        return False

    def _modify_src_check(self, server_id: str, src_ip_check: str, src_mac_check: str) -> bool:
        url = f"{self._compute_url}servers/{server_id}"
        data = {
            "src_ip_check": src_ip_check,
            "src_mac_check": src_mac_check
        }
        try:
            self._session.put(url=url, json=data, verify=False, timeout=30)
            return True
        except Exception:
            return False

    def delete_server(self, server_id: str) -> bool:
        url = f"{self._compute_url}servers/{server_id}"
        try:
            resp = self._session.delete(url=url, verify=False, timeout=60)
            return resp.status_code < 400
        except Exception as e:
            log.warning(f"删除服务器 {server_id} 异常: {e}")
            return False


# ============================================================
# SSH 客户端（精简版）
# ============================================================

try:
    import paramiko
except ImportError:
    paramiko = None


class SSHClient:
    """简易 SSH 客户端"""

    def __init__(self, ip: str, port: int = 22, username: str = "root", password: str = ""):
        self.ip = ip
        self.port = port
        self.username = username
        self.password = password
        self._client: Optional[paramiko.SSHClient] = None

    def connect(self, timeout: int = 30) -> bool:
        if paramiko is None:
            log.error("paramiko 未安装，请执行: pip install paramiko")
            return False
        try:
            self._client = paramiko.SSHClient()
            self._client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            self._client.connect(
                hostname=self.ip, port=self.port,
                username=self.username, password=self.password,
                timeout=timeout, banner_timeout=30, auth_timeout=30
            )
            log.info(f"SSH 连接成功: {self.ip}")
            return True
        except Exception as e:
            log.debug(f"SSH {self.ip} 连接失败: {e}")
            return False

    def exec_command(self, cmd: str, timeout: int = 120) -> Tuple[int, str, str]:
        if not self._client:
            return -1, "", "SSH not connected"
        try:
            stdin, stdout, stderr = self._client.exec_command(cmd, timeout=timeout)
            exit_code = stdout.channel.recv_exit_status()
            return exit_code, stdout.read().decode("utf-8", errors="replace"), stderr.read().decode("utf-8", errors="replace")
        except Exception as e:
            return -1, "", str(e)

    def exec(self, cmd: str, timeout: int = 120) -> "CommandResult":
        exit_code, stdout, stderr = self.exec_command(cmd, timeout)
        return CommandResult(exit_code, stdout, stderr)

    def close(self):
        if self._client:
            self._client.close()
            self._client = None


class CommandResult:
    def __init__(self, exit_code: int, stdout: str, stderr: str):
        self.exit_status_code = exit_code
        self.stdout = stdout
        self.stderr = stderr


# ============================================================
# 镜像 ID 映射（来自 mugen_creater.py get_guest_image_and_disk_image_id）
# ============================================================

IMAGE_ID_MAP = {
    "24.03-LTS-SP1": {
        "x86_64": {
            "guest_image_id": "08990f2f-61bd-4d5c-8dc6-aa0b9e309afa",
            "disk_image_id": "803fcb7b-4c6c-427e-8a35-bca8449d5a7d"
        },
        "aarch64": {
            "guest_image_id": "226f7d2f-47a7-4757-8423-e9c7bb92f88e",
            "disk_image_id": "d69806b4-eb49-47c1-84d5-a5e5fb531de5"
        },
        # riscv64 镜像 ID 需通过环境变量 GUEST_IMAGE_ID/DISK_IMAGE_ID 传入
        # 或在此处手动添加
    },
    "24.03-LTS-SP2": {
        "x86_64": {
            "guest_image_id": "08990f2f-61bd-4d5c-8dc6-aa0b9e309afa",
            "disk_image_id": "803fcb7b-4c6c-427e-8a35-bca8449d5a7d"
        },
        "aarch64": {
            "guest_image_id": "ad69b5d2-3d08-425c-8e80-5002570b48ba",
            "disk_image_id": "f2234812-70a6-4cd3-8930-752b000c6ca3"
        },
    },
    "24.03-LTS": {
        "x86_64": {
            "guest_image_id": "75b12675-37fa-4874-8c7a-1ad00d72cf1f",
            "disk_image_id": "0e8332ce-6ec2-44f7-82ff-53eabde77941"
        },
        "aarch64": {
            "guest_image_id": "0abbcc56-b97d-4085-8ed7-231232890a85",
            "disk_image_id": "e734d812-6383-4c17-8a20-c24262d64c60"
        },
    },
}


# ============================================================
# 核心功能
# ============================================================

def get_image_ids(os_version: str, os_arch: str) -> Tuple[Optional[str], Optional[str]]:
    """获取镜像 ID，优先使用环境变量，其次使用内置映射"""
    guest_id = os.environ.get("GUEST_IMAGE_ID")
    disk_id = os.environ.get("DISK_IMAGE_ID")
    if guest_id and disk_id:
        log.info(f"使用环境变量指定的镜像 ID: guest={guest_id}, disk={disk_id}")
        return guest_id, disk_id

    ver_map = IMAGE_ID_MAP.get(os_version, {})
    arch_map = ver_map.get(os_arch, {})
    guest_id = arch_map.get("guest_image_id")
    disk_id = arch_map.get("disk_image_id")
    if guest_id and disk_id:
        return guest_id, disk_id

    log.warning(f"未找到 {os_version}/{os_arch} 的镜像 ID 映射，请设置 GUEST_IMAGE_ID 和 DISK_IMAGE_ID 环境变量")
    return None, None


def wait_for_ssh(ip: str, username: str, password: str, timeout: int = 1800) -> bool:
    """等待 SSH 可达"""
    log.info(f"等待 SSH 可达: {ip} (超时 {timeout}s)...")
    start = time.time()
    while time.time() - start < timeout:
        try:
            client = SSHClient(ip, 22, username, password)
            if client.connect(timeout=10):
                result = client.exec("echo OK", timeout=10)
                if result.exit_status_code == 0 and "OK" in result.stdout:
                    log.info(f"SSH 可达: {ip}")
                    client.close()
                    return True
                client.close()
        except Exception:
            pass
        time.sleep(5)
    log.error(f"SSH {ip} 等待超时")
    return False


def update_repos(ip: str, username: str, password: str) -> bool:
    """更新 openEuler yum 源配置（基于 mugen_creater.py update_openEuler_repos_config）"""
    log.info(f"更新 yum 源配置: {ip}")
    client = SSHClient(ip, 22, username, password)
    if not client.connect():
        return False

    cmds = [
        "sed -i 's/repo\\.openeuler\\.org/mirror.iscas.ac.cn\\/openeuler/g' /etc/yum.repos.d/openEuler.repo",
        "sed -i 's/mirrors\\.openeuler\\.org/mirror.iscas.ac.cn\\/openeuler/g' /etc/yum.repos.d/openEuler.repo",
        'echo "sslverify=False" >> /etc/dnf/dnf.conf',
        "sed -i '$a sslverify=False' /etc/yum.conf",
        "yum clean all",
        "yum makecache",
    ]
    for cmd in cmds:
        result = client.exec(cmd, timeout=120)
        log.debug(f"[{ip}] {cmd[:60]}... exit={result.exit_status_code}")

    # 验证
    result = client.exec("cat /etc/yum.repos.d/openEuler.repo")
    log.info(f"[{ip}] repo 配置:\n{result.stdout[:500]}")
    client.close()
    return True


def prepare_environment(ip: str, username: str, password: str,
                        mugen_repo: str = None, mugen_branch: str = "main") -> bool:
    """准备测试环境：安装 git、克隆 os-autotest 代码"""
    client = SSHClient(ip, 22, username, password)
    if not client.connect():
        return False

    # 安装 git
    result = client.exec("dnf install -y git --nogpgcheck --skip-broken", timeout=180)
    log.info(f"[{ip}] 安装 git: exit={result.exit_status_code}")

    if mugen_repo:
        log.info(f"[{ip}] 克隆 os-autotest: {mugen_repo} (branch={mugen_branch})")
        result = client.exec(
            f"rm -rf /opt/os-autotest/ && mkdir -p /opt/ && "
            f"cd /opt/ && git clone -b {mugen_branch} --depth 1 {mugen_repo} /opt/os-autotest && "
            f"ls /opt/os-autotest/",
            timeout=300
        )
        if "mugen.sh" in result.stdout:
            log.info(f"[{ip}] os-autotest 克隆成功")
        else:
            log.warning(f"[{ip}] os-autotest 克隆可能失败: {result.stdout[:200]}")

    client.close()
    return True


def create_and_prepare_vms(args: argparse.Namespace) -> List[Dict]:
    """创建虚拟机并等待就绪"""
    # 获取 CloudPods 客户端
    keystone_url = args.cloudpods_url or os.environ.get(
        "CLOUDPODS_KEYSTONE_URL", "https://10.20.40.101:30500/v3"
    )
    cp_user = args.cloudpods_user or os.environ.get("CLOUDPODS_USER", "admin")
    cp_password = args.cloudpods_password or os.environ.get("CLOUDPODS_PASSWORD", "")
    cp = CloudPodsClient(keystone_url, cp_user, cp_password)
    if not cp.authenticate():
        log.error("CloudPods 认证失败，退出")
        return []

    # 获取镜像 ID
    guest_id, disk_id = get_image_ids(args.os_version, args.os_arch)
    if not guest_id or not disk_id:
        log.error("无法获取镜像 ID，请设置 GUEST_IMAGE_ID 和 DISK_IMAGE_ID 环境变量")
        return []

    # 网络列表
    nets_list = os.environ.get("CLOUDPODS_NET_LIST",
                               "e50836ad-cc39-4683-8d6b-072866f1981d").split(",")

    # 创建虚拟机
    log.info(f"=" * 60)
    log.info(f"开始创建 {args.vm_count} 台虚拟机")
    log.info(f"  OS: {args.os_version} / {args.os_arch}")
    log.info(f"  名称: {args.vm_name}")
    log.info(f"  规格: {args.sku}")
    log.info(f"=" * 60)

    server_ids = cp.create_server(
        guest_image_id=guest_id,
        disk_image_id=disk_id,
        arch=args.os_arch,
        vm_name=args.vm_name,
        sku=args.sku,
        count=args.vm_count,
        nets_list=nets_list,
        bios=args.bios,
    )

    if not server_ids:
        log.error("创建虚拟机失败")
        return []

    log.info(f"创建成功，共 {len(server_ids)} 台: {server_ids}")

    # 等待每台虚拟机就绪
    ssh_user = args.ssh_user or os.environ.get("USER", "root")
    ssh_password = args.ssh_password or os.environ.get("PASSWORD", "openEuler12#$")

    results = []
    for sid in server_ids:
        log.info(f"--- 处理服务器 {sid} ---")

        # 等待开机
        if not cp.wait_for_server_running(sid, args.timeout):
            log.error(f"服务器 {sid} 启动超时")
            continue

        # 获取 IP
        server_ip = cp.get_server_ip(sid)
        if not server_ip or not re.search(r"\d+\.\d+\.\d+\.\d+", server_ip):
            log.error(f"服务器 {sid} 无法获取有效 IP: {server_ip}")
            continue
        log.info(f"服务器 {sid} IP: {server_ip}")

        # 等待 SSH
        if not wait_for_ssh(server_ip, ssh_user, ssh_password, args.timeout):
            log.error(f"服务器 {sid} ({server_ip}) SSH 不可达")
            continue

        # 更新 yum 源
        if not args.skip_repo_update:
            update_repos(server_ip, ssh_user, ssh_password)

        # 准备环境（可选）
        if args.mugen_repo:
            prepare_environment(server_ip, ssh_user, ssh_password,
                                args.mugen_repo, args.mugen_branch)

        results.append({
            "server_id": sid,
            "server_ip": server_ip,
            "ssh_user": ssh_user,
            "ssh_password": ssh_password,
        })
        log.info(f"服务器 {sid} ({server_ip}) 就绪!")

    return results


def cleanup_vms(args: argparse.Namespace, server_ids: List[str]):
    """清理虚拟机"""
    keystone_url = args.cloudpods_url or os.environ.get(
        "CLOUDPODS_KEYSTONE_URL", "https://10.20.40.101:30500/v3"
    )
    cp_user = args.cloudpods_user or os.environ.get("CLOUDPODS_USER", "admin")
    cp_password = args.cloudpods_password or os.environ.get("CLOUDPODS_PASSWORD", "")
    cp = CloudPodsClient(keystone_url, cp_user, cp_password)
    if not cp.authenticate():
        log.error("CloudPods 认证失败，无法清理")
        return

    for sid in server_ids:
        log.info(f"删除服务器: {sid}")
        cp.delete_server(sid)


# ============================================================
# CLI
# ============================================================

def main():
    parser = argparse.ArgumentParser(
        description="CloudPods QEMU Launcher - 基于 mugen-generator 的精简虚拟机启动器",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
示例:
  # 创建 1 台 riscv64 虚拟机
  python cloudpods_launcher.py --os-version 24.03-LTS-SP1 --os-arch riscv64 \\
      -e GUEST_IMAGE_ID=xxx -e DISK_IMAGE_ID=yyy

  # 创建 3 台 x86_64 虚拟机
  python cloudpods_launcher.py --os-version 24.03-LTS-SP1 --os-arch x86_64 --vm-count 3

  # 清理虚拟机
  python cloudpods_launcher.py --action cleanup --server-ids id1,id2,id3

  # 只输出结果 JSON
  python cloudpods_launcher.py --os-version 24.03-LTS-SP1 --os-arch x86_64 -q
        """
    )

    # 基础参数
    parser.add_argument("--os-version", default="24.03-LTS-SP1",
                        help="操作系统版本 (默认: 24.03-LTS-SP1)")
    parser.add_argument("--os-arch", default="x86_64",
                        help="架构: x86_64 / aarch64 / riscv64 (默认: x86_64)")
    parser.add_argument("--vm-count", type=int, default=1,
                        help="创建虚拟机数量 (默认: 1)")
    parser.add_argument("--vm-name", default="cloudpods-launcher",
                        help="虚拟机名称前缀 (默认: cloudpods-launcher)")
    parser.add_argument("--sku", default="ecs.g1.c4m12",
                        help="服务器规格 (默认: ecs.g1.c4m12)")
    parser.add_argument("--bios", default="bios",
                        help="BIOS 类型 (默认: bios)")
    parser.add_argument("--timeout", type=int, default=1800,
                        help="等待虚拟机就绪超时秒数 (默认: 1800)")
    parser.add_argument("--action", choices=["create", "cleanup"], default="create",
                        help="操作: create / cleanup (默认: create)")
    parser.add_argument("--server-ids", default="",
                        help="清理模式下，要删除的 server_id 列表（逗号分隔）")

    # CloudPods 认证
    parser.add_argument("--cloudpods-url", default="",
                        help="CloudPods Keystone URL")
    parser.add_argument("--cloudpods-user", default="",
                        help="CloudPods 用户名")
    parser.add_argument("--cloudpods-password", default="",
                        help="CloudPods 密码")

    # SSH
    parser.add_argument("--ssh-user", default="",
                        help="SSH 用户名 (默认: root)")
    parser.add_argument("--ssh-password", default="",
                        help="SSH 密码")

    # 环境准备
    parser.add_argument("--skip-repo-update", action="store_true",
                        help="跳过 yum 源更新")
    parser.add_argument("--mugen-repo", default="",
                        help="os-autotest 代码仓库 URL（可选，提供则会 git clone）")
    parser.add_argument("--mugen-branch", default="main",
                        help="os-autotest 代码分支 (默认: main)")

    # 环境变量注入
    parser.add_argument("-e", "--env", action="append", default=[],
                        help="设置环境变量，格式: KEY=VALUE (可多次使用)")

    # 输出控制
    parser.add_argument("-q", "--quiet", action="store_true",
                        help="安静模式，仅输出 JSON 结果")
    parser.add_argument("--output-json", default="",
                        help="将结果写入 JSON 文件")

    args = parser.parse_args()

    # 处理 -e 环境变量
    for env_pair in args.env:
        if "=" in env_pair:
            key, value = env_pair.split("=", 1)
            os.environ[key] = value
            log.debug(f"设置环境变量: {key}={value}")

    if args.quiet:
        log.setLevel(logging.WARNING)

    # 执行操作
    if args.action == "cleanup":
        if not args.server_ids:
            log.error("cleanup 模式需要 --server-ids 参数")
            sys.exit(1)
        server_id_list = [s.strip() for s in args.server_ids.split(",") if s.strip()]
        cleanup_vms(args, server_id_list)
        print(json.dumps({"status": "cleanup_completed", "server_ids": server_id_list}, indent=2))
    else:
        results = create_and_prepare_vms(args)
        output = {
            "status": "success" if results else "failed",
            "os_version": args.os_version,
            "os_arch": args.os_arch,
            "vm_count": len(results),
            "servers": results,
        }
        print(json.dumps(output, indent=2, ensure_ascii=False))

        if args.output_json:
            with open(args.output_json, "w", encoding="utf-8") as f:
                json.dump(output, f, indent=2, ensure_ascii=False)
            log.info(f"结果已写入: {args.output_json}")


if __name__ == "__main__":
    main()
