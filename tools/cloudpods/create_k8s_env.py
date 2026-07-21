# -*- coding: utf-8 -*-
"""
CloudPods RISC-V Kubernetes Environment Creator

在 CloudPods 上创建一台 x86_64 KVM 虚拟机，在其中启动 N 个 QEMU RISC-V 虚拟机，
并按照 openRuyi RISC-V QEMU 多节点 Kubernetes Nexus SOP 部署 K8s 集群。

参考文档: https://openruyi.feishu.cn/wiki/SWvdwvwOfizoQOkNZX5c4KRqn9b
参考代码: create_server.py

使用方式: 修改 Env 类中的 k8s_node_count 即可指定节点数。
"""

import base64
import json
import logging
import os
import random
import re
import sys
import time
import uuid
from dataclasses import dataclass, field
from typing import Optional, List, Dict

import paramiko
import requests
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# ============================================================
# Logging
# ============================================================
log = logging.getLogger("create_k8s_env")
log.setLevel(logging.DEBUG)
_formatter = logging.Formatter(
    fmt="%(asctime)s | %(levelname)s | %(filename)s:%(lineno)d | %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
_console = logging.StreamHandler()
_console.setFormatter(_formatter)
_console.setLevel(logging.DEBUG)
log.addHandler(_console)


# ============================================================
# NodeConfig — 定义单个 K8s 节点
# ============================================================
@dataclass
class NodeConfig:
    hostname: str        # e.g. "openruyi-node-0"
    ip_cidr: str         # e.g. "192.168.77.11/24"
    ip_addr: str         # e.g. "192.168.77.11"
    tap_name: str        # e.g. "tap-orv-node0"
    ssh_port: int        # hostfwd port, e.g. 12055
    is_master: bool = False


# ============================================================
# K8sClusterConfig — K8s 集群全局配置
# ============================================================
@dataclass
class K8sClusterConfig:
    nodes: List[NodeConfig]
    bridge_name: str = "br-orv-k8s"
    bridge_ip: str = "192.168.77.1"
    bridge_subnet: str = "192.168.77.0/24"
    service_cidr: str = "10.96.0.0/12"
    pod_cidr: str = "10.244.0.0/16"
    cluster_dns: str = "10.96.0.10"
    nexus_base_url: str = "https://nexus.osssc.ac.cn/repository/openruyi-k8s/v1.35.5"
    assets_dir: str = "/opt/openruyi-k8s-multinode-assets"
    k8s_bin_dir: str = "/opt/openruyi-k8s/v1.35.5"

    @property
    def master(self) -> NodeConfig:
        for n in self.nodes:
            if n.is_master:
                return n
        raise RuntimeError("No master node defined")

    @property
    def workers(self) -> List[NodeConfig]:
        return [n for n in self.nodes if not n.is_master]


# ============================================================
# ExecResult & SSHClient
# ============================================================
class ExecResult:
    def __init__(self, exit_code: int, stdout: str = "", stderr: str = ""):
        self.exit_code = exit_code
        self.stdout = stdout
        self.stderr = stderr


class SSHClient:
    """基于 paramiko 的 SSH 客户端"""

    def __init__(self, ip: str = "127.0.0.1", port: int = 22,
                 username: str = "root", password: str = "",
                 sudo_password: str = "",
                 connect_timeout: int = 10, quiet: bool = False,
                 banner_timeout: int = 60, use_pty: bool = False):
        self.ip = ip
        self.port = port
        self.__username = username
        self.__password = password
        self.__sudo_password = sudo_password
        self.__connect_timeout = connect_timeout
        self.__banner_timeout = banner_timeout
        self.__quiet = quiet
        self.__use_pty = use_pty
        self.__ssh: Optional[paramiko.SSHClient] = None
        self.__connect()

    def __connect(self) -> bool:
        try:
            self.__ssh = paramiko.SSHClient()
            self.__ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            self.__ssh.connect(
                self.ip, port=self.port,
                username=self.__username, password=self.__password,
                look_for_keys=False, allow_agent=False,
                timeout=self.__connect_timeout,
                banner_timeout=self.__banner_timeout,
                auth_timeout=self.__connect_timeout,
            )
            if not self.__quiet:
                log.info(f"{self.ip}:{self.port} | SSH connected")
            return True
        except Exception as e:
            if not self.__quiet:
                log.warning(f"{self.ip}:{self.port} | SSH connect failed: {e}")
            return False

    def close(self):
        try:
            self.__ssh.close()
        except Exception:
            pass

    def exec(self, cmd: str, timeout: int = 60) -> ExecResult:
        if self.__sudo_password and cmd.startswith("sudo "):
            cmd = f"echo '{self.__sudo_password}' | sudo -S {cmd[5:]}"

        log.info(f"{self.ip}:{self.port} | exec: {cmd[:300]}")
        try:
            _in, _out, _err = self.__ssh.exec_command(
                cmd, timeout=timeout, get_pty=self.__use_pty,
            )
            exit_code = _out.channel.recv_exit_status()
            stdout = _out.read().decode('utf-8', 'ignore')
            stderr = _err.read().decode('utf-8', 'ignore')
            if exit_code != 0:
                log.error(f"{self.ip}:{self.port} | exit={exit_code} "
                          f"stdout={stdout[:200]} stderr={stderr[:200]}")
            else:
                log.info(f"{self.ip}:{self.port} | exit=0 stdout={stdout[:200]}")
            return ExecResult(exit_code, stdout, stderr)
        except Exception as e:
            log.error(f"{self.ip}:{self.port} | exec error: {e}")
            return ExecResult(255, "", str(e))

    def exec_script(self, script: str, timeout: int = 120) -> ExecResult:
        """
        安全执行 shell 脚本：base64 编码 -> 写入 -> 执行 -> 清理。

        用 base64 传输脚本内容，彻底规避单双引号、heredoc、
        特殊字符等所有 shell 转义问题。
        """
        encoded = base64.b64encode(script.encode("utf-8")).decode("ascii")
        return self.exec(
            f"sudo bash -c \"echo '{encoded}' | base64 -d > /tmp/_k8s_script.sh "
            f"&& bash /tmp/_k8s_script.sh && rm -f /tmp/_k8s_script.sh\"",
            timeout=timeout,
        )


# ============================================================
# CloudPods API Client
# ============================================================
class CloudPodsClient:
    """CloudPods REST API 客户端"""

    def __init__(self, keystone_url: str, username: str, password: str,
                 domain: str = "default", project: str = "system"):
        self.__keystone_url = keystone_url
        self.__username = username
        self.__password = password
        self.__domain = domain
        self.__project = project
        self.__session = self.__get_session()
        self.__endpoints = self.__get_endpoint()
        self.__compute_url = f"{self.__endpoints.get('region2', '')}/"

    def __get_session(self) -> Optional[requests.Session]:
        session = requests.Session()
        session.headers["User-Agent"] = "yunioncloud-go/201708"
        url = f"{self.__keystone_url}/auth/tokens"
        data = {
            "auth": {
                "context": {"source": "cli"},
                "identity": {
                    "methods": ["password"],
                    "password": {"user": {"name": self.__username, "password": self.__password}},
                },
                "scope": {"project": {"domain": {"name": self.__domain}, "name": self.__project}},
            }
        }
        try:
            rs = session.post(url=url, json=data, verify=False, timeout=600)
            if rs.status_code != 200:
                log.error(f"Keystone auth failed: status={rs.status_code}")
                return None
            token = rs.headers.get("X-Subject-Token", "")
            if not token:
                log.error("Keystone auth failed: no token")
                return None
            session.headers["X-Auth-Token"] = token
            log.info(f"CloudPods session created, token={token[:20]}...")
            return session
        except Exception as e:
            log.error(f"Keystone auth error: {e}")
            return None

    def __get_endpoint(self) -> Dict[str, str]:
        try:
            url = f"{self.__keystone_url}/endpoints"
            rs = self.__session.get(url=url, verify=False, timeout=600)
            if rs.status_code != 200:
                return {}
            data = rs.json()
            endpoints: Dict[str, str] = {}
            for ep in data.get("endpoints", []):
                name = ep.get("service_name", "")
                ep_url = ep.get("url", "")
                if name and ep_url:
                    if name in endpoints:
                        existing = endpoints[name]
                        if not re.match(r'https?://\d+\.\d+\.\d+\.\d+', existing) and \
                           re.match(r'https?://\d+\.\d+\.\d+\.\d+', ep_url):
                            endpoints[name] = ep_url
                    else:
                        endpoints[name] = ep_url
            return endpoints
        except Exception:
            return {}

    def _request(self, method: str, path: str, **kwargs) -> Optional[requests.Response]:
        url = f"{self.__compute_url}{path.lstrip('/')}"
        try:
            kwargs.setdefault("verify", False)
            kwargs.setdefault("timeout", 600)
            return self.__session.request(method, url, **kwargs)
        except Exception as e:
            log.error(f"Request {method} {url} failed: {e}")
            return None

    def create_server_by_guest_image(
        self,
        guest_image_id: str,
        disk_image_id: str,
        arch: str,
        disk_size_mb: int = 204800,
        nets_list: Optional[List[str]] = None,
        vm_name: str = "openruyi-autotest",
        sku: str = "ecs.g1.c4m12",
        count: int = 1,
        hypervisor: str = "kvm",
        bios: str = "BIOS",
    ) -> List[str]:
        if nets_list is None:
            nets_list = []
        nets = [{"network": net} for net in nets_list]

        server_config = {
            "auto_start": True,
            "generate_name": vm_name,
            "hypervisor": hypervisor,
            "disable_delete": False,
            "deploy_telegraf": True,
            "os_arch": arch,
            "nets": nets,
            "prefer_region": "default",
            "bios": bios,
            "guest_image_id": guest_image_id,
            "sku": sku,
            "disks": [
                {
                    "disk_type": "sys",
                    "index": 0,
                    "backend": "local",
                    "size": disk_size_mb,
                    "image_id": disk_image_id,
                    "medium": "ssd",
                }
            ],
            "reset_password": False,
        }

        log.info(f"Creating {count} server(s), name={vm_name}, sku={sku}, arch={arch}")
        rs = self._request("POST", "/servers", json={"count": count, "server": server_config})
        if rs is None or rs.status_code != 200:
            log.error(f"Create server failed: status={rs.status_code if rs else 'None'}")
            return []

        result = rs.json()
        server_ids: List[str] = []
        if "server" in result and "id" in result["server"]:
            server_ids.append(result["server"]["id"])
        elif "servers" in result:
            for s in result["servers"]:
                sid = s.get("body", {}).get("id", "")
                if sid:
                    server_ids.append(sid)
        log.info(f"Created servers: {server_ids}")
        return server_ids

    def get_server_detail(self, server_id: str) -> Optional[Dict]:
        rs = self._request("GET", f"/servers/{server_id}")
        if rs and rs.status_code == 200:
            return rs.json()
        return None

    def get_server_ip(self, server_id: str, network_id: str = "") -> Optional[str]:
        detail = self.get_server_detail(server_id)
        if not detail:
            return None
        server = detail.get("server", {})
        nics = server.get("nics", [])
        if not nics:
            return None
        if network_id:
            for nic in nics:
                if nic.get("network_id") == network_id:
                    return nic.get("ip_addr")
            return None
        return nics[0].get("ip_addr")

    def wait_for_server_is_on(self, server_id: str, timeout: int = 1800) -> bool:
        log.info(f"Waiting for server {server_id} to be running (timeout={timeout}s)...")
        start = time.time()
        running_count = 0
        while True:
            if time.time() - start > timeout:
                log.error(f"Timeout waiting for server {server_id}")
                return False
            detail = self.get_server_detail(server_id)
            if not detail:
                time.sleep(5)
                continue
            status = detail.get("server", {}).get("status", "")
            if "_fail" in status or status in ("disk_fail", "deploy_fail", "ready"):
                log.error(f"Server {server_id} in bad status: {status}")
                return False
            if status == "running":
                running_count += 1
                if running_count > 5:
                    log.info(f"Server {server_id} is running")
                    return True
                time.sleep(1)
            else:
                running_count = 0
                log.info(f"Server {server_id} status={status}, waiting...")
                time.sleep(5)

    def delete_server(self, server_id: str) -> bool:
        rs = self._request("DELETE", f"/servers/{server_id}")
        if rs and rs.status_code == 200:
            log.info(f"Deleted server {server_id}")
            return True
        return False


# ============================================================
# Helper functions
# ============================================================
def generate_random_mac() -> str:
    parts = [random.randint(0x00, 0xFF) for _ in range(6)]
    parts[0] = (parts[0] & 0xFE) | 0x02
    return ":".join(f"{x:02x}" for x in parts)


def wait_for_sshable(ip: str, port: int, username: str, password: str,
                     timeout: int = 3600, interval: int = 10) -> bool:
    log.info(f"Waiting for {ip}:{port} SSH (timeout={timeout}s)...")
    paramiko_logger = logging.getLogger("paramiko")
    old_level = paramiko_logger.level
    paramiko_logger.setLevel(logging.CRITICAL)
    try:
        for i in range(0, timeout, interval):
            ssh = None
            try:
                ssh = SSHClient(ip=ip, port=port, username=username, password=password,
                                connect_timeout=10, quiet=True)
                rs = ssh.exec("echo SSH_OK", timeout=60)
                if rs.exit_code == 0:
                    ssh.close()
                    log.info(f"{ip}:{port} SSH OK after {i}s")
                    return True
            except Exception:
                pass
            finally:
                if ssh:
                    try:
                        ssh.close()
                    except Exception:
                        pass
            time.sleep(interval)
    finally:
        paramiko_logger.setLevel(old_level)
    log.error(f"{ip}:{port} SSH timeout after {timeout}s")
    return False


def try_install_rpm(ssh: SSHClient, rpm: str, max_retries: int = 3) -> bool:
    check = ssh.exec(f"rpm -q {rpm}", timeout=60)
    if check.exit_code == 0:
        log.info(f"{ssh.ip}:{ssh.port} | {rpm} already installed")
        return True
    for i in range(max_retries):
        log.info(f"{ssh.ip}:{ssh.port} | installing {rpm} ({i + 1}/{max_retries})...")
        rs = ssh.exec(
            f"sudo dnf install -y --nogpgcheck --setopt=sslverify=0 {rpm}",
            timeout=3600,
        )
        if rs.exit_code == 0:
            return True
        if "No match for argument" in rs.stdout or "No match for argument" in rs.stderr:
            log.warning(f"{ssh.ip}:{ssh.port} | {rpm} not found in repos")
            return False
        time.sleep(10)
    return False


def try_wget(ssh: SSHClient, url: str, save_dir: str = "/opt",
             max_retries: int = 3, timeout: int = 7200) -> bool:
    filename = url.split("/")[-1]
    filepath = f"{save_dir}/{filename}"
    log.info(f"{ssh.ip}:{ssh.port} | downloading {url} -> {filepath}")

    for retry in range(max_retries):
        ssh.exec(f"sudo rm -f {filepath}")
        ssh.exec(f"cd {save_dir} && sudo wget -b -c -o {filepath}.wget-log {url}", timeout=60)

        start = time.time()
        prev_size = -1
        stable_count = 0

        while time.time() - start < timeout:
            time.sleep(10)
            rs = ssh.exec(f"sudo stat -c %s {filepath} 2>/dev/null || echo 0", timeout=60)
            size_str = rs.stdout.strip()
            current = int(size_str) if size_str.isdigit() else 0

            if current > 0:
                if current == prev_size:
                    stable_count += 1
                    if stable_count >= 5:
                        pid_rs = ssh.exec(f"pgrep -f 'wget.*{filename}'", timeout=60)
                        if not pid_rs.stdout.strip():
                            log.info(f"{ssh.ip}:{ssh.port} | download finished (size={current})")
                            ssh.exec(f"sudo rm -f {filepath}.wget-log")
                            return True
                        else:
                            log.warning(f"{ssh.ip}:{ssh.port} | download stalled, restarting...")
                            break
                else:
                    stable_count = 0
                    elapsed = int(time.time() - start)
                    log.info(f"{ssh.ip}:{ssh.port} | downloading... {current} bytes, {elapsed}s")
                prev_size = current
            else:
                if time.time() - start > 60:
                    log.warning(f"{ssh.ip}:{ssh.port} | file still 0 after 60s, retrying...")
                    break

        ssh.exec(f"sudo pkill -f 'wget.*{filename}' 2>/dev/null")
        ssh.exec(f"sudo rm -f {filepath} {filepath}.wget-log")
        log.warning(f"{ssh.ip}:{ssh.port} | download attempt {retry + 1} failed, retrying...")
        time.sleep(20)

    return False


def build_node_configs(env: "Env") -> List[NodeConfig]:
    """根据 env 参数自动生成所有节点配置"""
    nodes = []
    for i in range(env.k8s_node_count):
        is_master = (i == 0)
        suffix = f"node-{i}"
        hostname = f"openruyi-{suffix}"
        ip_octet = 11 + i
        nodes.append(NodeConfig(
            hostname=hostname,
            ip_cidr=f"192.168.77.{ip_octet}/24",
            ip_addr=f"192.168.77.{ip_octet}",
            tap_name=f"tap-orv-{suffix}",
            ssh_port=12055 + i,
            is_master=is_master,
        ))
    return nodes


# ============================================================
# K8s Deployment Functions
# ============================================================

def download_k8s_assets(ssh: SSHClient, cfg: K8sClusterConfig) -> bool:
    """下载 Nexus K8s 离线资产到 QEMU 虚拟机"""
    log.info("Downloading K8s assets from Nexus...")
    ssh.exec(f"sudo mkdir -p {cfg.assets_dir}", timeout=60)

    fetch_url = f"{cfg.nexus_base_url}/fetch-openruyi-rv-k8s-assets.sh"
    rs = ssh.exec(
        f"cd /tmp && sudo curl -k -fL -o fetch-openruyi-rv-k8s-assets.sh {fetch_url}",
        timeout=300,
    )
    if rs.exit_code != 0:
        log.warning("Fetch script download failed, trying manual download...")
        return _manual_download_assets(ssh, cfg)

    ssh.exec("sudo chmod +x /tmp/fetch-openruyi-rv-k8s-assets.sh", timeout=60)
    rs = ssh.exec(
        f"cd /tmp && DEST={cfg.assets_dir} BASE_URL={cfg.nexus_base_url} "
        f"sudo bash fetch-openruyi-rv-k8s-assets.sh",
        timeout=7200,
    )
    if rs.exit_code != 0:
        log.warning("Fetch script failed, trying manual download...")
        return _manual_download_assets(ssh, cfg)

    log.info("K8s assets downloaded successfully")
    return True


def _manual_download_assets(ssh: SSHClient, cfg: K8sClusterConfig) -> bool:
    """手动下载关键 K8s 资产文件（回退方案）"""
    log.info("Manually downloading critical K8s assets...")
    assets = [
        "bin/openruyi-k8s-v1.35.5-etcd-v3.6.6-riscv64.tar.gz",
        "bin/crictl-riscv64.tar.gz",
        "bin/cni-plugins-riscv64.tar.gz",
        "rpms/containerd-1.6.22-16.oe2403sp2.riscv64.rpm",
        "rpms/cloud-hypervisor-52.0.0+git20260602.1e18716-2.1.or.riscv64.rpm",
        "rpms/kata-containers-3.29.0-7.1.or.riscv64.rpm",
        "images/openruyi-k8s-demo-images-riscv64.tar",
        "images/calico-v3.32.0-riscv64.tar",
        "images/local-path-provisioner-v0.0.36-riscv64.tar",
        "images/busybox-1.36.1-riscv64.tar",
        "images/sonobuoy-v0.57.3-riscv64.tar",
        "manifests/calico-v3.32.0-crds.yaml",
        "manifests/calico-v3.32.0-openruyi-riscv64.yaml",
        "manifests/local-path-storage-v0.0.36-openruyi-riscv64.yaml",
        "demo/runtimeclass-kata-clh.yaml",
    ]
    for asset in assets:
        url = f"{cfg.nexus_base_url}/{asset}"
        remote_dir = f"{cfg.assets_dir}/{os.path.dirname(asset)}"
        ssh.exec(f"sudo mkdir -p {remote_dir}", timeout=60)
        try_wget(ssh, url, remote_dir, max_retries=2, timeout=3600)
    return True


# ---------- SOP Section 5: Node Base Init ----------

def init_k8s_node(ssh: SSHClient, node: NodeConfig, cfg: K8sClusterConfig) -> bool:
    """初始化 K8s 节点 —— SOP 文档第5节"""
    log.info(f"Initializing K8s node: {node.hostname} ({node.ip_addr})...")

    # Set hostname
    ssh.exec(f"sudo hostnamectl set-hostname {node.hostname}", timeout=60)

    # Configure eth0 (TAP bridge NIC) with static IP for inter-node communication.
    # QEMU 中 netdev tap 先于 netdev user 添加，因此在 guest 内部 eth0=TAP bridge、
    # eth1=user-mode NAT。节点间通信必须走 eth0。
    # 先清理 eth1 上可能残留的静态 IP（旧版脚本 bug），再配置 eth0。
    ssh.exec(
        f"sudo ip addr del {node.ip_addr}/24 dev eth1 2>/dev/null",
        timeout=30,
    )
    ssh.exec(
        f"sudo ip addr add {node.ip_addr}/24 dev eth0 2>/dev/null; sudo ip link set eth0 up",
        timeout=60,
    )

    # 持久化 eth0 静态 IP 配置：写入 NetworkManager connection 或 ifcfg 文件
    ssh.exec_script(rf"""
if command -v nmcli &>/dev/null; then
    # 使用 NetworkManager 持久化 eth0 静态 IP
    nmcli con del eth0-static 2>/dev/null || true
    nmcli con add type ethernet ifname eth0 con-name eth0-static \
        ip4 {node.ip_addr}/24 \
        ipv4.method manual \
        ipv4.never-default yes \
        connection.autoconnect yes 2>/dev/null || true
    nmcli con up eth0-static 2>/dev/null || true
else
    # 回退：写入传统 network-scripts 格式
    cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << 'NETEOF'
DEVICE=eth0
BOOTPROTO=static
IPADDR={node.ip_addr}
PREFIX=24
ONBOOT=yes
NETEOF
fi
""", timeout=120)

    # Install base packages
    pkgs = ("runc iptables-nft nftables conntrack-tools socat jq tar gzip "
            "findutils procps iproute2 xfsprogs openssl curl")
    rs = ssh.exec(f"sudo dnf install -y {pkgs}", timeout=3600)
    if rs.exit_code != 0:
        log.error(f"Failed to install base packages: {rs.stderr[:500]}")
        return False

    # Install containerd, cloud-hypervisor, kata from offline RPMs
    rs = ssh.exec(
        f"cd {cfg.assets_dir} && sudo dnf install -y --nogpgcheck "
        f"rpms/containerd-*.rpm rpms/cloud-hypervisor-*.rpm rpms/kata-containers-*.rpm",
        timeout=600,
    )
    if rs.exit_code != 0:
        log.error(f"Failed to install containerd/CLH/kata RPMs: {rs.stderr[:500]}")
        return False

    # Install K8s binaries
    ssh.exec(f"sudo mkdir -p {cfg.k8s_bin_dir} /opt/cni/bin", timeout=60)
    rs = ssh.exec(
        f"sudo tar -C {cfg.k8s_bin_dir} -xf "
        f"{cfg.assets_dir}/bin/openruyi-k8s-v1.35.5-etcd-v3.6.6-riscv64.tar.gz",
        timeout=300,
    )
    if rs.exit_code != 0:
        log.error(f"Failed to extract K8s binaries: {rs.stderr[:500]}")
        return False

    for pkg, target in [
        ("crictl-riscv64.tar.gz", "/usr/local/bin"),
        ("cni-plugins-riscv64.tar.gz", "/opt/cni/bin"),
    ]:
        # CNI tarball 内文件路径包含 cni/bin/ 前缀（如 cni/bin/loopback），
        # 使用 --strip-components=2 去除该前缀直接安装到 /opt/cni/bin/
        strip = "--strip-components=2" if "cni" in pkg else ""
        ssh.exec(f"sudo tar -C {target} {strip} -xf {cfg.assets_dir}/bin/{pkg}", timeout=120)

    for bin_name in ["kubectl", "kubelet", "kube-proxy", "etcd", "etcdctl"]:
        ssh.exec(
            f"sudo ln -sf {cfg.k8s_bin_dir}/bin/{bin_name} /usr/local/bin/{bin_name}",
            timeout=60,
        )

    # Kernel modules
    ssh.exec_script(r"""cat >/etc/modules-load.d/k8s.conf <<'EOF'
overlay
br_netfilter
nf_conntrack
nf_nat
nf_tables
nft_compat
nft_chain_nat
nft_nat
nft_masq
vxlan
kvm
EOF

for m in overlay br_netfilter nf_conntrack nf_nat nf_tables nft_compat \
    nft_chain_nat nft_nat nft_masq vxlan kvm; do
    modprobe "$m" || true
done""", timeout=120)

    # sysctl
    ssh.exec_script(r"""cat >/etc/sysctl.d/99-kubernetes.conf <<'EOF'
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system
test -e /dev/kvm""", timeout=120)

    # Start containerd & import images
    ssh.exec("sudo systemctl enable --now containerd", timeout=120)
    images = [
        "images/openruyi-k8s-demo-images-riscv64.tar",
        "images/calico-v3.32.0-riscv64.tar",
        "images/local-path-provisioner-v0.0.36-riscv64.tar",
        "images/busybox-1.36.1-riscv64.tar",
        "images/sonobuoy-v0.57.3-riscv64.tar",
    ]
    for img in images:
        rs = ssh.exec(f"sudo ctr -n k8s.io images import {cfg.assets_dir}/{img}", timeout=600)
        if rs.exit_code != 0:
            log.warning(f"Failed to import image {img}: {rs.stderr[:200]}")

    # Configure Kata (if script exists)
    kata_script = f"{cfg.assets_dir}/scripts/configure-kata-clh-openruyi.sh"
    check = ssh.exec(f"test -f {kata_script}", timeout=60)
    if check.exit_code == 0:
        ssh.exec(f"sudo bash {kata_script}", timeout=300)

    # Containerd CRI config
    ssh.exec_script(rf"""mkdir -p /etc/containerd
cat >/etc/containerd/config.toml <<'EOF'
version = 2

[plugins."io.containerd.grpc.v1.cri"]
  sandbox_image = "localhost/pause-riscv64:3.10"

  [plugins."io.containerd.grpc.v1.cri".cni]
    bin_dir = "/opt/cni/bin"
    conf_dir = "/etc/cni/net.d"
    max_conf_num = 1

  [plugins."io.containerd.grpc.v1.cri".containerd]
    default_runtime_name = "runc"

    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
      runtime_type = "io.containerd.runc.v2"

      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
        SystemdCgroup = false

    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.kata-clh]
      runtime_type = "io.containerd.kata.v2"
EOF

mkdir -p /etc/systemd/system/containerd.service.d
cat >/etc/systemd/system/containerd.service.d/10-kata-openruyi.conf <<'EOF'
[Service]
Environment=KATA_CONF_FILE=/usr/share/defaults/kata-containers/configuration-openruyi-clh-rpm-20260603.toml
EOF

systemctl daemon-reload
systemctl restart containerd""", timeout=120)

    log.info(f"Node {node.hostname} initialization complete!")
    return True


# ---------- SOP Section 6: Control Plane Bootstrap ----------

def bootstrap_k8s_control_plane(master_ssh: SSHClient, cfg: K8sClusterConfig) -> bool:
    """在 master 上执行 K8s 控制面引导 —— SOP 文档第6节"""
    log.info("Bootstrapping Kubernetes control plane on master...")

    master = cfg.master
    master_ssh.exec(
        "sudo mkdir -p /etc/kubernetes/pki /var/lib/etcd /var/lib/kubelet /var/lib/kube-proxy",
        timeout=60,
    )

    # Build make_client_cert calls for ALL nodes
    cert_calls = ""
    for node in cfg.nodes:
        cert_calls += (
            f"make_client_cert kubelet-{node.hostname} "
            f"system:node:{node.hostname} system:nodes\n"
        )

    cert_script = rf"""cd /etc/kubernetes/pki

# CA
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -key ca.key -subj "/CN=kubernetes-ca" \
    -days 3650 -out ca.crt

# Service Account key
openssl genrsa -out sa.key 4096
openssl rsa -in sa.key -pubout -out sa.pub

# API Server cert
cat >apiserver.cnf <<'EOF'
[req]
distinguished_name=req
req_extensions=v3_req
prompt=no
[v3_req]
subjectAltName=@alt_names
[alt_names]
DNS.1=kubernetes
DNS.2=kubernetes.default
DNS.3=kubernetes.default.svc
DNS.4=kubernetes.default.svc.cluster.local
IP.1=10.96.0.1
IP.2=127.0.0.1
IP.3={master.ip_addr}
EOF

openssl genrsa -out apiserver.key 4096
openssl req -new -key apiserver.key -subj "/CN=kube-apiserver" \
    -out apiserver.csr -config apiserver.cnf
openssl x509 -req -in apiserver.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
    -out apiserver.crt -days 3650 -extensions v3_req -extfile apiserver.cnf

# Client cert helper
make_client_cert() {{
    local name="$1" cn="$2" org="$3"
    openssl genrsa -out "${{name}}.key" 4096
    openssl req -new -key "${{name}}.key" \
        -subj "/CN=${{cn}}/O=${{org}}" -out "${{name}}.csr"
    openssl x509 -req -in "${{name}}.csr" -CA ca.crt -CAkey ca.key \
        -CAcreateserial -out "${{name}}.crt" -days 3650
}}

make_client_cert admin kubernetes-admin system:masters
make_client_cert controller-manager system:kube-controller-manager system:kube-controller-manager
make_client_cert scheduler system:kube-scheduler system:kube-scheduler
make_client_cert kube-proxy system:kube-proxy system:node-proxier
{cert_calls}"""

    rs = master_ssh.exec_script(cert_script, timeout=300)
    if rs.exit_code != 0:
        log.error(f"Certificate generation failed: {rs.stderr[:500]}")
        return False

    # ----- Generate kubeconfig files -----
    kubeconfig_calls = ""
    for node in cfg.nodes:
        kubeconfig_calls += (
            f"make_kubeconfig /etc/kubernetes/kubelet-{node.hostname}.conf "
            f"system:node:{node.hostname} "
            f"/etc/kubernetes/pki/kubelet-{node.hostname}.crt "
            f"/etc/kubernetes/pki/kubelet-{node.hostname}.key\n"
        )

    kubeconfig_script = rf"""make_kubeconfig() {{
    local file="$1" user="$2" cert="$3" key="$4"
    kubectl config set-cluster openruyi \
        --certificate-authority=/etc/kubernetes/pki/ca.crt \
        --embed-certs=true \
        --server=https://{master.ip_addr}:6443 \
        --kubeconfig="${{file}}"
    kubectl config set-credentials "${{user}}" \
        --client-certificate="${{cert}}" \
        --client-key="${{key}}" \
        --embed-certs=true \
        --kubeconfig="${{file}}"
    kubectl config set-context default --cluster=openruyi --user="${{user}}" \
        --kubeconfig="${{file}}"
    kubectl config use-context default --kubeconfig="${{file}}"
}}

make_kubeconfig /etc/kubernetes/admin.conf admin \
    /etc/kubernetes/pki/admin.crt /etc/kubernetes/pki/admin.key
make_kubeconfig /etc/kubernetes/controller-manager.conf controller-manager \
    /etc/kubernetes/pki/controller-manager.crt /etc/kubernetes/pki/controller-manager.key
make_kubeconfig /etc/kubernetes/scheduler.conf scheduler \
    /etc/kubernetes/pki/scheduler.crt /etc/kubernetes/pki/scheduler.key
make_kubeconfig /etc/kubernetes/kube-proxy.conf kube-proxy \
    /etc/kubernetes/pki/kube-proxy.crt /etc/kubernetes/pki/kube-proxy.key
{kubeconfig_calls}
mkdir -p /root/.kube
cp /etc/kubernetes/admin.conf /root/.kube/config"""

    rs = master_ssh.exec_script(kubeconfig_script, timeout=300)
    if rs.exit_code != 0:
        log.error(f"Kubeconfig generation failed: {rs.stderr[:500]}")
        return False

    # ----- etcd systemd service -----
    master_ssh.exec_script(rf"""cat >/etc/systemd/system/openruyi-etcd.service <<'EOF'
[Unit]
Description=openRuyi etcd
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
Environment=ETCD_UNSUPPORTED_ARCH=riscv64
ExecStart={cfg.k8s_bin_dir}/bin/etcd \
    --advertise-client-urls=http://127.0.0.1:2379 \
    --listen-client-urls=http://127.0.0.1:2379 \
    --data-dir=/var/lib/etcd \
    --name={master.hostname}
Restart=always
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF""", timeout=60)

    # ----- kube-apiserver systemd service -----
    master_ssh.exec_script(rf"""cat >/etc/systemd/system/openruyi-kube-apiserver.service <<'EOF'
[Unit]
Description=openRuyi Kubernetes API Server
After=openruyi-etcd.service
Requires=openruyi-etcd.service

[Service]
ExecStart={cfg.k8s_bin_dir}/bin/kube-apiserver \
    --advertise-address={master.ip_addr} \
    --bind-address=0.0.0.0 \
    --secure-port=6443 \
    --etcd-servers=http://127.0.0.1:2379 \
    --service-cluster-ip-range={cfg.service_cidr} \
    --client-ca-file=/etc/kubernetes/pki/ca.crt \
    --tls-cert-file=/etc/kubernetes/pki/apiserver.crt \
    --tls-private-key-file=/etc/kubernetes/pki/apiserver.key \
    --service-account-key-file=/etc/kubernetes/pki/sa.pub \
    --service-account-signing-key-file=/etc/kubernetes/pki/sa.key \
    --service-account-issuer=https://kubernetes.default.svc.cluster.local \
    --authorization-mode=Node,RBAC \
    --enable-admission-plugins=NodeRestriction \
    --allow-privileged=true
Restart=always
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF""", timeout=60)

    # ----- kube-controller-manager systemd service -----
    master_ssh.exec_script(rf"""cat >/etc/systemd/system/openruyi-kube-controller-manager.service <<'EOF'
[Unit]
Description=openRuyi Kubernetes Controller Manager
After=openruyi-kube-apiserver.service
Requires=openruyi-kube-apiserver.service

[Service]
ExecStart={cfg.k8s_bin_dir}/bin/kube-controller-manager \
    --kubeconfig=/etc/kubernetes/controller-manager.conf \
    --cluster-cidr={cfg.pod_cidr} \
    --service-cluster-ip-range={cfg.service_cidr} \
    --allocate-node-cidrs=true \
    --cluster-signing-cert-file=/etc/kubernetes/pki/ca.crt \
    --cluster-signing-key-file=/etc/kubernetes/pki/ca.key \
    --root-ca-file=/etc/kubernetes/pki/ca.crt \
    --service-account-private-key-file=/etc/kubernetes/pki/sa.key
Restart=always

[Install]
WantedBy=multi-user.target
EOF""", timeout=60)

    # ----- kube-scheduler systemd service -----
    master_ssh.exec_script(rf"""cat >/etc/systemd/system/openruyi-kube-scheduler.service <<'EOF'
[Unit]
Description=openRuyi Kubernetes Scheduler
After=openruyi-kube-apiserver.service
Requires=openruyi-kube-apiserver.service

[Service]
ExecStart={cfg.k8s_bin_dir}/bin/kube-scheduler \
    --kubeconfig=/etc/kubernetes/scheduler.conf
Restart=always

[Install]
WantedBy=multi-user.target
EOF""", timeout=60)

    # ----- Start control plane -----
    master_ssh.exec("sudo systemctl daemon-reload", timeout=60)

    # 先 enable 所有服务（不启动），再逐个 start，便于定位哪个服务启动失败
    rs = master_ssh.exec(
        "sudo systemctl enable openruyi-etcd openruyi-kube-apiserver "
        "openruyi-kube-controller-manager openruyi-kube-scheduler",
        timeout=120,
    )
    log.info(f"enable result: exit={rs.exit_code} stderr={rs.stderr[:800]}")

    svc_names = [
        ("openruyi-etcd", 60),
        ("openruyi-kube-apiserver", 120),
        ("openruyi-kube-controller-manager", 60),
        ("openruyi-kube-scheduler", 60),
    ]
    for svc, svc_timeout in svc_names:
        rs = master_ssh.exec(f"sudo systemctl start {svc}", timeout=svc_timeout)
        if rs.exit_code != 0:
            log.error(f"systemctl start {svc} failed: "
                      f"exit={rs.exit_code} stdout={rs.stdout[:500]} stderr={rs.stderr[:500]}")
            # 抓取 journal 日志帮助诊断
            j_rs = master_ssh.exec(f"sudo journalctl -u {svc} --no-pager -n 30", timeout=60)
            log.error(f"{svc} journal:\n{j_rs.stdout[-2000:]}")
            return False
        log.info(f"{svc} started successfully")

    # Wait for control plane health
    log.info("Waiting for control plane to be ready...")
    time.sleep(30)
    for attempt in range(30):
        rs = master_ssh.exec(
            "sudo kubectl get --raw /healthz 2>/dev/null || echo 'NOT_READY'",
            timeout=60,
        )
        if rs.exit_code == 0 and "ok" in rs.stdout:
            log.info("Kubernetes control plane is healthy!")
            break
        log.info(f"  Waiting for control plane... attempt {attempt + 1}/30")
        time.sleep(10)
    else:
        log.warning("Control plane health check timed out, continuing...")

    # ----- Fix controller-manager RBAC permissions -----
    # K8s v1.35.5 默认 system:kube-controller-manager ClusterRole 缺少 patch nodes、
    # create configmaps、create controllerrevisions 等重要权限，导致 PodCIDR 分配失败、
    # DaemonSet 无法创建 revision、节点永远 NotReady。
    # 修复：将 cluster-admin ClusterRole 绑定给 system:kube-controller-manager。
    log.info("Fixing controller-manager RBAC permissions...")
    master_ssh.exec_script(r"""kubectl create clusterrolebinding openruyi-cm-admin \
    --clusterrole=cluster-admin \
    --user=system:kube-controller-manager 2>/dev/null || \
kubectl patch clusterrolebinding openruyi-cm-admin --type=json \
    -p='[{"op":"replace","path":"/roleRef/name","value":"cluster-admin"}]' 2>/dev/null || true
""", timeout=60)
    log.info("Controller-manager RBAC permissions fixed")

    # 重启 CM 使新权限生效
    master_ssh.exec("sudo systemctl restart openruyi-kube-controller-manager", timeout=60)
    time.sleep(10)  # 等待 CM 重启并分配 PodCIDR
    log.info("Controller-manager restarted with new permissions")

    log.info("Kubernetes control plane bootstrap complete!")
    return True


# ---------- Copy certs from master to a node ----------

def distribute_certs_to_node(master_ssh: SSHClient, node_ssh: SSHClient,
                              node: NodeConfig, cfg: K8sClusterConfig) -> bool:
    """将证书和 kubeconfig 从 master 传输到一个节点"""
    log.info(f"Distributing certs to {node.hostname}...")
    node_ssh.exec("sudo mkdir -p /etc/kubernetes /etc/kubernetes/pki", timeout=60)

    files_to_copy = [
        "/etc/kubernetes/pki/ca.crt",
        f"/etc/kubernetes/kubelet-{node.hostname}.conf",
        "/etc/kubernetes/kube-proxy.conf",
    ]

    for f in files_to_copy:
        rs = master_ssh.exec(f"sudo cat {f}", timeout=60)
        if rs.exit_code != 0:
            log.error(f"Failed to read {f} from master: {rs.stderr[:200]}")
            return False
        content = rs.stdout
        node_ssh.exec_script(f"cat > {f} << 'EOF'\n{content}\nEOF", timeout=60)

    log.info(f"Certificates distributed to {node.hostname}")
    return True


# ---------- SOP Section 7: Start kubelet & kube-proxy ----------

def start_kubelet_kube_proxy(ssh: SSHClient, node: NodeConfig,
                              cfg: K8sClusterConfig) -> bool:
    """启动 kubelet 和 kube-proxy —— SOP 文档第7节"""
    log.info(f"Starting kubelet and kube-proxy on {node.hostname}...")

    ssh.exec_script(rf"""mkdir -p /var/lib/kubelet /var/lib/kube-proxy /etc/kubernetes

# Kubelet config
cat >/var/lib/kubelet/config.yaml <<'EOF'
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
cgroupDriver: cgroupfs
clusterDNS:
- {cfg.cluster_dns}
clusterDomain: cluster.local
failSwapOn: false
containerRuntimeEndpoint: unix:///run/containerd/containerd.sock
EOF

# Kubelet systemd service
cat >/etc/systemd/system/kubelet.service <<'EOF'
[Unit]
Description=Kubernetes Kubelet
After=containerd.service network-online.target
Requires=containerd.service

[Service]
ExecStart=/usr/local/bin/kubelet \
    --config=/var/lib/kubelet/config.yaml \
    --kubeconfig=/etc/kubernetes/kubelet-{node.hostname}.conf \
    --hostname-override={node.hostname} \
    --node-ip={node.ip_addr}
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Kube-proxy config
cat >/var/lib/kube-proxy/config.yaml <<'EOF'
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
bindAddress: 0.0.0.0
clusterCIDR: {cfg.pod_cidr}
mode: iptables
clientConnection:
  kubeconfig: /etc/kubernetes/kube-proxy.conf
EOF

# Kube-proxy systemd service
cat >/etc/systemd/system/openruyi-kube-proxy.service <<'EOF'
[Unit]
Description=Kubernetes Kube Proxy
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/local/bin/kube-proxy --config=/var/lib/kube-proxy/config.yaml
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now kubelet openruyi-kube-proxy""", timeout=180)

    log.info(f"kubelet and kube-proxy started on {node.hostname}")
    return True


# ---------- SOP Section 8: Calico & Addons ----------

def install_calico_and_addons(master_ssh: SSHClient, cfg: K8sClusterConfig,
                               all_node_ssh: dict = None) -> bool:
    """安装 Calico、RuntimeClass 和 local-path 存储 —— SOP 文档第8节
    
    Args:
        master_ssh: Master 节点 SSH 客户端
        cfg: K8s 集群配置
        all_node_ssh: {hostname: SSHClient} 所有节点的 SSH 客户端映射，
                      用于在每个节点上手动写入 CNI 配置
    """
    log.info("Installing Calico, RuntimeClass, and local-path storage...")

    master_ssh.exec(
        f"sudo kubectl apply -f {cfg.assets_dir}/manifests/calico-v3.32.0-crds.yaml",
        timeout=120,
    )
    time.sleep(5)
    master_ssh.exec(
        f"sudo kubectl apply -f {cfg.assets_dir}/manifests/calico-v3.32.0-openruyi-riscv64.yaml",
        timeout=120,
    )

    # Patch Calico DaemonSet: 将 IP 自动检测网卡从 eth1 改为 eth0
    # （因为我们把静态 IP 分配到了 TAP bridge 网卡 eth0）
    master_ssh.exec_script(r"""kubectl -n kube-system patch ds calico-node --type=json \
    -p='[{"op":"replace","path":"/spec/template/spec/containers/0/env/6/value","value":"interface=eth0"}]' 2>/dev/null || true
""", timeout=60)

    # ---- Workaround: 手动为每个节点生成 CNI 配置 ----
    # Calico init 容器在 RISC-V 上可能因 runc OCI runtime bug
    # (lstat /proc/0/ns/ipc: no such file or directory) 而崩溃，
    # 导致 /etc/cni/net.d/10-calico.conflist 无法自动生成。
    # 折衷方案：直接从 Calico ConfigMap 读取模板，替换后写入所有节点。
    log.info("Manually generating CNI config for all nodes (Calico init container workaround)...")
    if all_node_ssh is None:
        all_node_ssh = {}
    
    # 等待 ConfigMap 就绪
    for _ in range(20):
        rs = master_ssh.exec(
            "sudo kubectl get configmap calico-config -n kube-system -o yaml 2>/dev/null",
            timeout=60,
        )
        if rs.exit_code == 0 and "calico-config" in rs.stdout:
            break
        time.sleep(3)
    
    for node_name, node_ssh in all_node_ssh.items():
        # 生成 CNI 配置文件，nodename 替换为实际主机名
        log.info(f"Writing CNI config for {node_name}...")
        node_ssh.exec_script(rf"""mkdir -p /etc/cni/net.d
cat > /etc/cni/net.d/10-calico.conflist << 'CNIEOF'
{{
  "name": "k8s-pod-network",
  "cniVersion": "0.3.1",
  "plugins": [
    {{
      "type": "calico",
      "log_level": "info",
      "log_file_path": "/var/log/calico/cni/cni.log",
      "datastore_type": "kubernetes",
      "nodename": "{node_name}",
      "mtu": 0,
      "ipam": {{"type": "calico-ipam"}},
      "policy": {{"type": "k8s"}},
      "kubernetes": {{"kubeconfig": "/etc/kubernetes/kubelet-{node_name}.conf"}}
    }},
    {{
      "type": "portmap",
      "snat": true,
      "capabilities": {{"portMappings": true}}
    }}
  ]
}}
CNIEOF
chmod 644 /etc/cni/net.d/10-calico.conflist
""", timeout=60)

    # 写入 CNI 配置后重启所有节点的 kubelet，使新配置生效
    log.info("Restarting kubelet on all nodes to pick up CNI config...")
    for node_name, node_ssh in all_node_ssh.items():
        node_ssh.exec("sudo systemctl restart kubelet 2>/dev/null || true", timeout=60)
    log.info("CNI config manually generated for all nodes")

    # RuntimeClass (kata-clh)
    runtimeclass_file = f"{cfg.assets_dir}/demo/runtimeclass-kata-clh.yaml"
    check = master_ssh.exec(f"test -f {runtimeclass_file}", timeout=60)
    if check.exit_code == 0:
        master_ssh.exec(f"sudo kubectl apply -f {runtimeclass_file}", timeout=60)

    # Local-path storage
    master_ssh.exec(
        f"sudo kubectl apply -f "
        f"{cfg.assets_dir}/manifests/local-path-storage-v0.0.36-openruyi-riscv64.yaml",
        timeout=120,
    )
    master_ssh.exec(
        "sudo kubectl -n local-path-storage rollout status deploy/local-path-provisioner "
        "--timeout=180s",
        timeout=300,
    )

    log.info("Calico and addons installed!")
    return True


# ---------- Final Validation ----------

def verify_k8s_cluster(master_ssh: SSHClient, cfg: K8sClusterConfig) -> bool:
    """验证 K8s 集群状态 —— kubectl get nodes 所有节点 Ready"""
    log.info("=" * 60)
    log.info("Verifying K8s cluster status...")
    log.info("=" * 60)

    expected_count = len(cfg.nodes)
    max_wait = 300  # 最长等待 5 分钟让节点变 Ready

    for attempt in range(0, max_wait, 15):
        rs = master_ssh.exec("sudo kubectl get nodes --no-headers 2>/dev/null", timeout=60)
        if rs.exit_code != 0:
            log.warning(f"kubectl get nodes failed: {rs.stderr[:200]}")
            time.sleep(15)
            continue

        lines = [l for l in rs.stdout.strip().split("\n") if l.strip()]
        ready_count = sum(
            1 for line in lines if len(line.split()) >= 2 and line.split()[1] == "Ready"
        )

        log.info(f"Nodes: {ready_count}/{expected_count} Ready (detected {len(lines)} total)")
        for line in lines:
            log.info(f"  {line}")

        if ready_count >= expected_count:
            log.info("=" * 60)
            log.info(f"K8s cluster is HEALTHY! All {expected_count} node(s) Ready!")
            log.info("=" * 60)
            master_ssh.exec("sudo kubectl get nodes -o wide", timeout=60)
            return True

        time.sleep(15)

    # Final check
    rs = master_ssh.exec("sudo kubectl get nodes -o wide", timeout=60)
    log.warning(f"Cluster may not be fully ready after {max_wait}s.")
    log.warning(f"Final state:\n{rs.stdout}")
    return False


# ============================================================
# Main Logic
# ============================================================
def create_k8s_env(env: "Env") -> bool:
    """
    主流程：
    1. 在 CloudPods 上创建 1 台 x86_64 KVM 虚拟机
    2. 在 CloudPods host 上安装 QEMU、下载 RISC-V 镜像
    3. 创建 bridge + TAP 设备，启动 N 个 QEMU RISC-V VM
    4. 在 QEMU VM 中下载 Nexus K8s 资产、初始化节点
    5. 在 master 上引导 K8s 控制面
    6. 分发证书到 worker 节点
    7. 启动所有节点的 kubelet/kube-proxy
    8. 安装 Calico 和 addons
    9. 验证集群状态 (kubectl get nodes)
    """

    # Build node configs
    nodes = build_node_configs(env)
    cfg = K8sClusterConfig(nodes=nodes)

    log.info("=" * 60)
    log.info(f"K8s Cluster: {len(cfg.nodes)} node(s)")
    for n in cfg.nodes:
        role = "MASTER (control-plane)" if n.is_master else "WORKER"
        log.info(f"  {n.hostname}: {n.ip_addr} (SSH port {n.ssh_port}) [{role}]")
    log.info("=" * 60)

    # ---- Step 1: Connect to CloudPods ----
    log.info("Step 1: Connecting to CloudPods...")
    cp = CloudPodsClient(
        keystone_url=env.cloudpods_keystone_url,
        username=env.cloudpods_user,
        password=env.cloudpods_password,
    )
    if cp._CloudPodsClient__session is None:
        log.error("Failed to authenticate with CloudPods")
        return False

    # ---- Step 2: Create server ----
    log.info("Step 2: Creating CloudPods server...")
    nets = env.cloudpods_kvm_net_list.split(",")
    create_nets = nets[:1]
    vm_uuid = str(uuid.uuid4())
    vm_name = f"{env.server_name_prefix}-{vm_uuid.split('-', 1)[1]}"
    server_ids = cp.create_server_by_guest_image(
        guest_image_id=env.guest_image_id,
        disk_image_id=env.disk_image_id,
        arch="x86_64",
        disk_size_mb=204800,
        nets_list=create_nets,
        vm_name=vm_name,
        sku=env.server_sku,
        count=1,
        hypervisor="kvm",
        bios=env.cloudpods_host_bios,
    )
    if not server_ids:
        log.error("Failed to create CloudPods server")
        return False

    # ---- Step 3: Wait for server to be running ----
    log.info("Step 3: Waiting for server to be running...")
    for sid in server_ids:
        if not cp.wait_for_server_is_on(sid):
            for s in server_ids:
                cp.delete_server(s)
            return False

    # ---- Step 4: Get server IP ----
    log.info("Step 4: Getting server IP...")
    first_net = nets[0] if nets else ""
    host_ip = cp.get_server_ip(server_ids[0], first_net)
    if not host_ip:
        for s in server_ids:
            cp.delete_server(s)
        return False
    log.info(f"Server {server_ids[0]} -> {host_ip}")

    # ---- Step 5: Wait for server SSH ----
    log.info(f"Step 5: Waiting for server SSH on {host_ip}...")
    if not wait_for_sshable(host_ip, 22, env.cloudpods_server_user,
                             env.cloudpods_server_password):
        return False

    host_ssh = SSHClient(ip=host_ip, port=22,
                         username=env.cloudpods_server_user,
                         password=env.cloudpods_server_password)

    # ---- Step 6: Install QEMU & packages ----
    log.info("Step 6: Installing QEMU and required packages on host...")
    if env.delete_default_yum_repos.lower() == "yes":
        host_ssh.exec(
            "sudo sed -i 's|repo.openeuler.org|mirrors.iscas.ac.cn/openeuler|g' "
            "/etc/yum.repos.d/*.repo"
        )
        host_ssh.exec(
            "sudo sed -i 's|mirrors.openeuler.org|mirrors.iscas.ac.cn/openeuler|g' "
            "/etc/yum.repos.d/*.repo"
        )
        host_ssh.exec("sudo dnf clean all", timeout=3600)
        host_ssh.exec("sudo dnf makecache", timeout=600)

    for pkg in ["wget", "xz", "zstd", "screen", "expect", "firewalld",
                "qemu-img", "bridge-utils"]:
        if not try_install_rpm(host_ssh, pkg):
            log.error(f"Failed to install {pkg}")
            return False

    host_ssh.exec("sudo systemctl start firewalld; sudo systemctl enable firewalld")

    # Install QEMU
    if env.os_version == "openRuyi-RVA23":
        if not try_install_rpm(host_ssh, "libslirp-devel"):
            return False
        nexus_repo = (
            "[nexus-qemu]\n"
            "name=Nexus QEMU Repo\n"
            "baseurl=https://nexus.gray.oepkgs.net/repository/yum-hosted/\n"
            "enabled=1\n"
            "gpgcheck=0\n"
            "priority=1"
        )
        host_ssh.exec_script(
            f"cat > /etc/yum.repos.d/nexus-qemu.repo << 'EOF'\n{nexus_repo}\nEOF",
            timeout=60,
        )
        host_ssh.exec("sudo yum clean all; sudo rm -rf /var/cache/yum")
        rs = host_ssh.exec(
            "sudo yum install -y qemu-10.1.2 --disablerepo=* --enablerepo=nexus-qemu",
            timeout=180,
        )
        if rs.exit_code != 0:
            log.error(f"QEMU install failed: {rs.stderr[:500]}")
            return False
        qemu_path = "/usr/local/qemu/bin/qemu-system-riscv64"
    else:
        if not try_install_rpm(host_ssh, "qemu-system-riscv"):
            return False
        qemu_path = "qemu-system-riscv64"

    rs = host_ssh.exec(f"{qemu_path} --version", timeout=60)
    if rs.exit_code != 0:
        log.error(f"QEMU version check failed: {rs.stderr[:500]}")
        return False
    log.info(f"QEMU version: {rs.stdout.strip()[:200]}")

    # ---- Step 7: Firewall ----
    log.info("Step 7: Configuring firewall...")
    for node in cfg.nodes:
        host_ssh.exec(
            f"sudo firewall-cmd --zone=public --add-port={node.ssh_port}/tcp --permanent",
            timeout=60,
        )
    host_ssh.exec("sudo firewall-cmd --reload", timeout=60)

    # ---- Step 8: Download RISC-V image & firmware ----
    log.info("Step 8: Downloading RISC-V image and firmware...")
    host_ssh.exec("sudo rm -rf /opt/*.xz /opt/*.zst /opt/*.fd /opt/*.qcow2 2>/dev/null")
    for url in [env.riscv_image_url, env.riscv_virt_code_url, env.riscv_virt_vars_url]:
        if not try_wget(host_ssh, url, "/opt"):
            return False

    # ---- Step 9: Decompress image ----
    log.info("Step 9: Decompressing RISC-V image...")
    image_name = env.riscv_image_url.split("/")[-1]
    if ".qcow2.xz" in image_name:
        rs = host_ssh.exec("cd /opt && sudo xz -d -f *.qcow2.xz", timeout=3600)
        if rs.exit_code != 0:
            return False
        image_name = image_name.replace(".qcow2.xz", ".qcow2")
    elif ".qcow2.zst" in image_name:
        rs = host_ssh.exec("cd /opt && sudo zstd -d -f *.qcow2.zst", timeout=3600)
        if rs.exit_code != 0:
            return False
        image_name = image_name.replace(".qcow2.zst", ".qcow2")

    virt_code_name = env.riscv_virt_code_url.split("/")[-1]
    virt_vars_name = env.riscv_virt_vars_url.split("/")[-1]
    host_ssh.exec(f"sudo cp /opt/{virt_vars_name} /opt/{virt_vars_name}.template")

    # ---- Step 10: Create K8s bridge and TAP devices ----
    log.info("Step 10: Setting up K8s bridge and TAP devices...")
    tap_setup_lines = []
    for node in cfg.nodes:
        tap_setup_lines.append(f"ip tuntap add {node.tap_name} mode tap 2>/dev/null")
        tap_setup_lines.append(
            f"ip link set {node.tap_name} master {cfg.bridge_name} 2>/dev/null"
        )
        tap_setup_lines.append(f"ip link set {node.tap_name} up")
    tap_setup_block = "\n".join(tap_setup_lines)

    bridge_script = f"""
ip link add {cfg.bridge_name} type bridge 2>/dev/null
ip addr add {cfg.bridge_ip}/24 dev {cfg.bridge_name} 2>/dev/null
ip link set {cfg.bridge_name} up

{tap_setup_block}

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p
iptables -t nat -A POSTROUTING -s {cfg.bridge_subnet} -j MASQUERADE
"""
    host_ssh.exec_script(bridge_script, timeout=120)

    # ---- Step 11: Launch QEMU VMs ----
    log.info(f"Step 11: Launching {len(cfg.nodes)} QEMU VM(s)...")
    qemu_cpu = env.riscv_qemu_cpu
    qemu_memory = env.riscv_qemu_memory

    for idx, node in enumerate(cfg.nodes):
        log.info(f"Launching QEMU for {node.hostname} (SSH port {node.ssh_port})...")

        per_vm_vars = f"RISCV_VIRT_VARS_{idx}.fd"
        host_ssh.exec(f"sudo cp /opt/{virt_vars_name}.template /opt/{per_vm_vars}")

        base_name = f"riscv-k8s-{node.hostname}.qcow2"
        rs = host_ssh.exec(
            f"cd /opt && sudo qemu-img create -f qcow2 -F qcow2 "
            f"-b {image_name} {base_name}",
            timeout=3600,
        )
        if rs.exit_code != 0:
            log.error(f"Failed to create qcow2 for {node.hostname}: {rs.stderr}")
            return False
        time.sleep(3)

        # Build QEMU command (mirrors create_server.py proven config)
        qemu_cmd = f"cd /opt && {qemu_path}"
        qemu_cmd += " -nographic"
        qemu_cmd += " -machine virt,pflash0=pflash0,pflash1=pflash1"
        qemu_cmd += f" -smp {qemu_cpu} -m {qemu_memory}G"
        qemu_cmd += " -rtc base=utc,clock=host"

        # BIOS: UEFI with pflash
        qemu_cmd += (
            f" -blockdev node-name=pflash0,driver=file,read-only=on,"
            f"filename={virt_code_name}"
        )
        qemu_cmd += (
            f" -blockdev node-name=pflash1,driver=file,"
            f"filename={per_vm_vars}"
        )
        qemu_cmd += " -cpu rva23s64"

        # System disk
        qemu_cmd += f" -drive file={base_name},format=qcow2,id=hd0,if=none"
        qemu_cmd += " -object rng-random,filename=/dev/urandom,id=rng0"
        qemu_cmd += " -device virtio-vga"
        qemu_cmd += " -device virtio-rng-device,rng=rng0"
        qemu_cmd += " -device virtio-blk-device,drive=hd0"
        qemu_cmd += " -device qemu-xhci -usb -device usb-kbd -device usb-tablet"

        # TAP NIC for inter-node communication (netdev FIRST, then device)
        mac1 = generate_random_mac()
        qemu_cmd += (
            f" -netdev tap,id=net0,ifname={node.tap_name},script=no,downscript=no"
            f" -device virtio-net-pci,netdev=net0,mac={mac1}"
        )

        # User-mode NIC with hostfwd for SSH (netdev FIRST, then device)
        mac2 = generate_random_mac()
        qemu_cmd += (
            f" -netdev user,id=net1,hostfwd=tcp::{node.ssh_port}-:22"
            f" -device virtio-net-pci,netdev=net1,mac={mac2}"
        )

        script_path = f"/opt/start_qemu_{node.hostname}.sh"
        host_ssh.exec_script(f"cat > {script_path} << 'QEMUEOF'\n{qemu_cmd}\nQEMUEOF", timeout=60)

        screen_name = f"qemu-k8s-{node.hostname}"
        host_ssh.exec(f"sudo screen -S {screen_name} -X quit 2>/dev/null")
        time.sleep(2)
        host_ssh.exec(
            f"cd /opt && sudo screen -S {screen_name} -d -m bash {script_path}",
            timeout=60,
        )
        log.info(f"QEMU {node.hostname}: screen session '{screen_name}' started")
        time.sleep(15)

    # ---- Step 12: Wait for QEMU SSH ----
    log.info(f"Step 12: Waiting for {len(cfg.nodes)} QEMU VM(s) to be SSHable...")
    for node in cfg.nodes:
        if not wait_for_sshable(
            ip=host_ip,
            port=node.ssh_port,
            username=env.riscv_default_username,
            password=env.riscv_default_password,
            timeout=env.qemu_ssh_timeout,
        ):
            log.error(f"QEMU {node.hostname} SSH not reachable")
            return False
        log.info(f"QEMU {node.hostname}: SSH reachable")

    # ---- Build SSH clients for all nodes ----
    node_ssh_map: Dict[str, SSHClient] = {}
    for node in cfg.nodes:
        node_ssh_map[node.hostname] = SSHClient(
            ip=host_ip, port=node.ssh_port,
            username=env.riscv_default_username,
            password=env.riscv_default_password,
            sudo_password=env.riscv_default_password,
            use_pty=True,
        )

    # ---- Configure NOPASSWD sudo in all QEMU guests ----
    # QEMU 镜像默认启用 requiretty，必须分配 PTY 才能 sudo。
    # 但 echo password | sudo -S 在 PTY 下行为不可靠，
    # 所以第一步先用 PTY 配置 NOPASSWD，后续所有操作不再需要密码。
    log.info("Configuring NOPASSWD sudo in all QEMU guests...")
    for node in cfg.nodes:
        vm_ssh = node_ssh_map[node.hostname]
        rs = vm_ssh.exec(
            f"echo '{env.riscv_default_password}' | sudo -S sh -c "
            f"\"echo '{env.riscv_default_username} ALL=(ALL) NOPASSWD: ALL' "
            f">> /etc/sudoers.d/99-openruyi-nopasswd\"",
            timeout=60,
        )
        if rs.exit_code != 0:
            log.warning(f"Failed to configure NOPASSWD sudo on {node.hostname}, "
                        f"will use password for sudo")
        else:
            log.info(f"NOPASSWD sudo configured on {node.hostname}")
            # 关闭该连接的 sudo_password，后续不再走 pipe 密码逻辑
            vm_ssh._SSHClient__sudo_password = ""

    # NOPASSWD 配置完成后关闭所有 VM SSH 连接的 PTY
    # paramiko 的 recv_exit_status() 在 PTY 模式下不可靠，会阻塞卡死
    for node in cfg.nodes:
        node_ssh_map[node.hostname]._SSHClient__use_pty = False

    # ---- Step 13: Configure yum repos inside QEMU guests ----
    log.info("Step 13: Configuring yum repos in QEMU guests...")
    for node in cfg.nodes:
        vm_ssh = node_ssh_map[node.hostname]
        if env.delete_default_yum_repos.lower() == "yes":
            vm_ssh.exec(
                "sudo sed -i 's/^metalink=/#metalink=/g' /etc/yum.repos.d/*.repo"
            )
            vm_ssh.exec(
                "sudo sed -i 's/metalink=/#metalink=/g' /etc/yum.repos.d/*.repo"
            )
        if env.add_yum_repos:
            for r_idx, repo_url in enumerate(env.add_yum_repos.split(",")):
                repo_content = (
                    f"[local-{r_idx}]\n"
                    f"name=local-{r_idx}\n"
                    f"baseurl={repo_url}\n"
                    f"priority=10\n"
                    f"enabled=1\n"
                    f"gpgcheck=0\n"
                    f"skip_if_unavailable=1"
                )
                vm_ssh.exec_script(
                    f"cat > /etc/yum.repos.d/local-{r_idx}.repo "
                    f"<< 'EOF'\n{repo_content}\nEOF",
                    timeout=60,
                )
            vm_ssh.exec("sudo dnf clean all", timeout=3600)
            vm_ssh.exec("sudo dnf makecache", timeout=600)
        try_install_rpm(vm_ssh, "ntpdate")
        vm_ssh.exec("sudo ntpdate cn.pool.ntp.org", timeout=3600)
        vm_ssh.exec("sudo timedatectl set-timezone Asia/Shanghai")

    # ---- Step 14: Download K8s assets ----
    log.info("Step 14: Downloading K8s assets on all QEMU VMs...")
    for node in cfg.nodes:
        vm_ssh = node_ssh_map[node.hostname]
        try_install_rpm(vm_ssh, "curl")
        if not download_k8s_assets(vm_ssh, cfg):
            log.error(f"Failed to download K8s assets on {node.hostname}")
            return False

    # ---- Step 15: Initialize all nodes (SOP Section 5) ----
    log.info("Step 15: Initializing all K8s nodes (SOP Section 5)...")
    for node in cfg.nodes:
        vm_ssh = node_ssh_map[node.hostname]
        if not init_k8s_node(vm_ssh, node, cfg):
            log.error(f"Failed to initialize {node.hostname}")
            return False

    # ---- Step 16: Bootstrap K8s control plane on master (SOP Section 6) ----
    log.info("Step 16: Bootstrapping K8s control plane (SOP Section 6)...")
    master_ssh = node_ssh_map[cfg.master.hostname]
    if not bootstrap_k8s_control_plane(master_ssh, cfg):
        log.error("Failed to bootstrap control plane")
        return False

    # ---- Step 17: Distribute certs to all workers (SOP Section 6 end) ----
    log.info("Step 17: Distributing certs to all worker nodes...")
    for node in cfg.workers:
        worker_ssh = node_ssh_map[node.hostname]
        if not distribute_certs_to_node(master_ssh, worker_ssh, node, cfg):
            log.error(f"Failed to distribute certs to {node.hostname}")
            return False

    # ---- Step 18: Start kubelet & kube-proxy on ALL nodes (SOP Section 7) ----
    log.info("Step 18: Starting kubelet & kube-proxy on all nodes (SOP Section 7)...")
    for node in cfg.nodes:
        vm_ssh = node_ssh_map[node.hostname]
        if not start_kubelet_kube_proxy(vm_ssh, node, cfg):
            log.error(f"Failed to start kubelet/kube-proxy on {node.hostname}")
            return False

    # Wait for nodes to register
    log.info("Waiting for nodes to register with the cluster...")
    time.sleep(30)

    # ---- Step 19: Install Calico & addons (SOP Section 8) ----
    log.info("Step 19: Installing Calico and addons (SOP Section 8)...")
    install_calico_and_addons(master_ssh, cfg, node_ssh_map)

    # ---- Step 20: Verify cluster ----
    log.info("Step 20: Verifying cluster health...")
    success = verify_k8s_cluster(master_ssh, cfg)

    # ---- Done ----
    log.info("=" * 60)
    if success:
        log.info("K8S CLUSTER SETUP COMPLETE! All nodes Ready!")
    else:
        log.warning("K8S cluster setup finished but verification not fully passing")
    log.info("=" * 60)
    log.info(f"CloudPods Server ID: {server_ids[0]}")
    log.info(f"Host IP: {host_ip}")
    for node in cfg.nodes:
        role = "Master" if node.is_master else "Worker"
        log.info(
            f"  {role}: ssh -p {node.ssh_port} {env.riscv_default_username}@{host_ip}  "
            f"({node.hostname}, {node.ip_addr})"
        )
    log.info(
        f"kubectl: ssh -p {cfg.master.ssh_port} {env.riscv_default_username}@{host_ip} "
        f"sudo kubectl get nodes"
    )
    log.info("=" * 60)
    return success


# ============================================================
# Env Configuration Class
# ============================================================
class Env:
    """配置类 —— 修改 k8s_node_count 即可指定 K8s 节点数"""

    # ---- CloudPods 连接 ----
    cloudpods_keystone_url: str = "https://10.20.40.101:30500/v3"
    cloudpods_user: str = "admin"
    cloudpods_password: str = "jSj@2008"

    # ---- CloudPods 虚拟机规格 ----
    os_version: str = "openRuyi-RVA23"
    guest_image_id: str = "6f59c2c8-73f8-449b-8546-b6cf2b5564a0"
    disk_image_id: str = "40fb8262-0566-4877-8eb0-d991903e9be7"
    cloudpods_host_bios: str = "BIOS"
    server_name_prefix: str = "redrose2100-k8s"
    server_sku: str = "ecs.g1.c32m64"
    cloudpods_kvm_net_list: str = (
        "efdb73ac-d785-47a1-82bf-65c2229eacca,"
        "3e0ac273-6da8-4188-821b-d97a84cb7754,"
        "04bc4008-f5a6-40a0-84aa-5fcd76e3f2ef,"
        "0f71d7ea-6e7a-42bc-81c3-290e396581a7,"
        "b7272573-29ea-4e46-8c27-22b81503aee6"
    )

    # ---- 虚拟机 SSH 凭据 ----
    cloudpods_server_user: str = "root"
    cloudpods_server_password: str = "ISRCpassword@123"

    # ---- YUM 源 ----
    delete_default_yum_repos: str = "yes"
    add_yum_repos: str = "https://diamond.oerv.ac.cn/openruyi/riscv64/"

    # ---- RISC-V QEMU 资源 ----
    riscv_default_username: str = "openruyi"
    riscv_default_password: str = "openruyi"
    riscv_image_url: str = (
        "https://s3.develop.oepkgs.net/demo/openruyi-virt_riscv64.qcow2.xz"
    )
    riscv_virt_code_url: str = (
        "https://s3.develop.oepkgs.net/demo/RISCV_VIRT_CODE.fd"
    )
    riscv_virt_vars_url: str = (
        "https://s3.develop.oepkgs.net/demo/RISCV_VIRT_VARS.fd"
    )

    # ---- K8s 节点数 ----
    k8s_node_count: int = 2  # Node 0 = master, Node 1..N-1 = workers

    # ---- QEMU VM 规格 ----
    riscv_qemu_cpu: int = 8
    riscv_qemu_memory: int = 8

    # ---- 超时 ----
    qemu_ssh_timeout: int = 10800


# ============================================================
# Entry Point
# ============================================================
if __name__ == "__main__":
    env = Env()
    success = create_k8s_env(env)
    sys.exit(0 if success else 1)
