#!/bin/sh -eu
# Security test: nmap — TCP/UDP port scanning
# Tests basic port scanning functionality on localhost
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

echo "=== 测试: 基本端口扫描 ==="

rlRun 'nmap -T4 --host-timeout 30s -p 22,80,443 localhost 2>&1' 0 "TCP 端口扫描 (常用端口)"
rlRun 'nmap -T4 --host-timeout 30s -sU -p 53 localhost 2>&1' 0 "UDP 端口扫描 (DNS)"
rlRun 'nmap -T4 --host-timeout 30s -p 1-100 localhost 2>&1' 0 "TCP 端口扫描 (1-100)"

# === TEARDOWN ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y nmap 2>/dev/null || true
    echo "TEARDOWN: removed nmap"
fi

echo ""
echo "All nmap port scan tests passed!"
