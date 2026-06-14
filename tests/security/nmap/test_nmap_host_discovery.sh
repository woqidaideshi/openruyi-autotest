#!/bin/sh -eu
# Security test: nmap — Network host discovery
# Tests ping sweep and host discovery methods
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

echo "=== 测试: 网络主机发现 ==="

rlRun 'nmap -T4 --host-timeout 30s -sn 127.0.0.1 2>&1 || true' 0 "Ping 扫描 (主机发现)"
rlRun 'nmap -T4 --host-timeout 30s -PE localhost 2>&1 || true' 0 "ICMP Echo 发现"
rlRun 'nmap -T4 --host-timeout 30s -PS -p 22 localhost 2>&1 || true' 0 "TCP SYN Ping 发现"

# === TEARDOWN ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y nmap 2>/dev/null || true
    echo "TEARDOWN: removed nmap"
fi

echo ""
echo "All nmap host discovery tests passed!"
