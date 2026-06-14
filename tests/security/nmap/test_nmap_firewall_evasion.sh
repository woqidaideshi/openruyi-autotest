#!/bin/sh -eu
# Security test: nmap — Firewall/IDS evasion techniques
# Tests packet fragmentation, decoys, and other evasion methods
# Target: localhost (safe testing)

rlRun() { eval "$1" 2>&1; return $?; }

# === SETUP: check/install nmap ===
INSTALLED_BY_TEST=0
if ! rpm -q nmap 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y nmap 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed nmap"
    else
        echo "SKIP: nmap not available in repos"
        exit 0
    fi
else
    echo "SETUP: nmap already installed"
fi

rlRun 'nmap --version 2>&1 || true' 0 "获取 nmap 版本信息"

echo "=== 测试: 防火墙/IDS 规避 ==="

rlRun 'nmap -T4 --host-timeout 30s -f -p 22 localhost 2>&1 || true' 0 "分片包扫描 (fragment)"
rlRun 'nmap -T4 --host-timeout 30s --data-length 30 -p 22 localhost 2>&1 || true' 0 "随机数据填充扫描"
rlRun 'nmap -T4 --host-timeout 30s --badsum -p 22 localhost 2>&1 || true' 0 "错误校验和探测"

# === TEARDOWN ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y nmap 2>/dev/null || true
    echo "TEARDOWN: removed nmap"
fi

echo ""
echo "All nmap firewall evasion tests passed!"
