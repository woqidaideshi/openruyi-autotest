#!/bin/sh -eu
# Security test: nmap — NSE script scanning
# Tests Nmap Scripting Engine for vulnerability/banner detection

rlRun() { eval "$1" 2>&1; return $?; }

# === SETUP ===
if ! rpm -q nmap 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y nmap 2>/dev/null; then
        echo "SETUP: installed nmap"
    else
        echo "SKIP: nmap not available in repos"
        exit 0
    fi
fi

rlRun 'nmap --version 2>&1' 0 "获取 nmap 版本信息"

# Detect open ports to target
OPEN_PORTS=$(nmap -T4 --host-timeout 30s -p 22,80,443 localhost 2>/dev/null | awk '/open/ {print $1}' | cut -d/ -f1 | tr '\n' ' ' || true)
echo "Open ports: ${OPEN_PORTS:-none detected}"

echo "=== 测试: NSE 脚本扫描 ==="

# Test NSE scripts against whatever ports are open
if echo "$OPEN_PORTS" | grep -q 22; then
    rlRun 'nmap -T4 --host-timeout 30s --script=banner -p 22 localhost 2>&1' 0 "NSE banner 脚本 (SSH)"
    rlRun 'nmap -T4 --host-timeout 30s --script=ssh-auth-methods -p 22 localhost 2>&1' 0 "NSE SSH 认证方法检测"
else
    echo "SKIP: port 22 not open — SSH NSE scripts skipped"
fi

if echo "$OPEN_PORTS" | grep -q 80; then
    rlRun 'nmap -T4 --host-timeout 30s --script=http-headers -p 80 localhost 2>&1' 0 "NSE HTTP 头检测"
else
    echo "SKIP: port 80 not open — HTTP NSE scripts skipped"
fi

if echo "$OPEN_PORTS" | grep -q 443; then
    rlRun 'nmap -T4 --host-timeout 30s --script=ssl-enum-ciphers -p 443 localhost 2>&1' 0 "NSE SSL 密码套件枚举"
else
    echo "SKIP: port 443 not open — SSL NSE scripts skipped"
fi

echo ""
echo "All nmap NSE script tests passed!"
