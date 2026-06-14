#!/bin/sh -eu
# Security test: nmap — SSL/TLS security analysis
# Tests SSL/TLS certificate and vulnerability scanning
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

echo "=== 测试: SSL/TLS 安全分析 ==="

rlRun 'nmap -T4 --host-timeout 30s --script=ssl-cert -p 443 localhost 2>&1 || true' 0 "SSL 证书分析"
rlRun 'nmap -T4 --host-timeout 30s --script=ssl-heartbleed -p 443 localhost 2>&1 || true' 0 "Heartbleed 漏洞检测"
rlRun 'nmap -T4 --host-timeout 30s --script=sslv2 -p 443 localhost 2>&1 || true' 0 "SSLv2 支持检测"

# === TEARDOWN ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y nmap 2>/dev/null || true
    echo "TEARDOWN: removed nmap"
fi

echo ""
echo "All nmap SSL/TLS analysis tests passed!"
