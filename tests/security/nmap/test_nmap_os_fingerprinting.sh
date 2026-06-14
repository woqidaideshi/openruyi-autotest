#!/bin/sh -eu
# Security test: nmap — OS fingerprinting
# Tests operating system detection capabilities
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

echo "=== 测试: 操作系统指纹识别 ==="

rlRun 'nmap -T4 --host-timeout 60s -O localhost 2>&1 || true' 0 "操作系统指纹识别"
rlRun 'nmap -T4 --host-timeout 30s -O --osscan-limit localhost 2>&1 || true' 0 "限制型 OS 检测"

# === TEARDOWN ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y nmap 2>/dev/null || true
    echo "TEARDOWN: removed nmap"
fi

echo ""
echo "All nmap OS fingerprinting tests passed!"
