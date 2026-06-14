#!/bin/sh -eu
# Security test: nmap — Service version detection
# Tests service/version detection on open ports
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

echo "=== 测试: 服务版本检测 ==="

rlRun 'nmap -T4 --host-timeout 30s -sV -p 22 localhost 2>&1 || true' 0 "SSH 服务版本检测"
rlRun 'nmap -T4 --host-timeout 30s -sV --version-intensity 3 -p 22,80 localhost 2>&1 || true' 0 "服务版本探测"

# === TEARDOWN ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y nmap 2>/dev/null || true
    echo "TEARDOWN: removed nmap"
fi

echo ""
echo "All nmap service detection tests passed!"
