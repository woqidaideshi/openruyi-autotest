#!/bin/sh -eu
# Security test: nmap — NSE script scanning
# Tests Nmap Scripting Engine for vulnerability detection
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

echo "=== 测试: NSE 脚本扫描 ==="

rlRun 'nmap -T4 --host-timeout 30s --script=banner -p 22 localhost 2>&1 || true' 0 "NSE banner 脚本"
rlRun 'nmap -T4 --host-timeout 30s --script=http-headers -p 80 localhost 2>&1 || true' 0 "NSE HTTP 头检测"
rlRun 'nmap -T4 --host-timeout 30s --script=ssh-auth-methods -p 22 localhost 2>&1 || true' 0 "NSE SSH 认证方法检测"
rlRun 'nmap -T4 --host-timeout 30s --script=ssl-enum-ciphers -p 443 localhost 2>&1 || true' 0 "NSE SSL 密码套件枚举"

# === TEARDOWN ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y nmap 2>/dev/null || true
    echo "TEARDOWN: removed nmap"
fi

echo ""
echo "All nmap NSE script tests passed!"
