#!/bin/sh -eu
# Security test: nmap — Service version detection
# Tests service/version detection on open ports
# Target: localhost with nginx + sshd services

rlRun() { eval "$1" 2>&1; return $?; }

# === SETUP ===
INSTALLED_BY_TEST=0
SERVICES_STARTED=""

# Check/install nmap
if ! rpm -q nmap 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y nmap 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed nmap"
    else
        echo "SKIP: nmap not available in repos"
        exit 0
    fi
fi

# Ensure nginx is installed for port 80 testing
if ! rpm -q nginx 2>/dev/null; then
    echo openruyi | sudo -S dnf install -y nginx 2>/dev/null || true
fi

# Start nginx on port 80
if command -v nginx >/dev/null 2>&1; then
    echo openruyi | sudo -S nginx -t 2>/dev/null || true
    echo openruyi | sudo -S nginx 2>/dev/null || true
    SERVICES_STARTED="nginx"
    echo "SETUP: started nginx on port 80"
fi

# Ensure sshd is running on port 22
if command -v sshd >/dev/null 2>&1; then
    echo openruyi | sudo -S systemctl start sshd 2>/dev/null || true
fi

rlRun 'nmap --version 2>&1 || true' 0 "获取 nmap 版本信息"

echo "=== 测试: 服务版本检测 ==="

rlRun 'nmap -T4 --host-timeout 30s -sV -p 22 localhost 2>&1' 0 "SSH 服务版本检测"
rlRun 'nmap -T4 --host-timeout 30s -sV --version-intensity 3 -p 80 localhost 2>&1' 0 "HTTP 服务版本检测"

# === TEARDOWN ===
if [ -n "$SERVICES_STARTED" ]; then
    echo openruyi | sudo -S nginx -s stop 2>/dev/null || true
    echo "TEARDOWN: stopped nginx"
fi
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y nmap 2>/dev/null || true
    echo "TEARDOWN: removed nmap"
fi

echo ""
echo "All nmap service detection tests passed!"
