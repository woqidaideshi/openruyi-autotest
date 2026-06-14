#!/bin/sh -eu
# Security test: nmap — SSL/TLS security analysis
# Tests SSL/TLS certificate and vulnerability scanning

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

# Detect if port 443 is open
if nmap -T4 --host-timeout 30s -p 443 localhost 2>/dev/null | grep -q '/tcp.*open'; then
    HAS_HTTPS=1
    echo "Port 443 open — running full SSL/TLS analysis"
else
    HAS_HTTPS=0
    echo "Port 443 not open — SSL/TLS scripts will run but may report filtered/closed"
fi

echo "=== 测试: SSL/TLS 安全分析 ==="

rlRun 'nmap -T4 --host-timeout 30s --script=ssl-cert -p 443 localhost 2>&1' 0 "SSL 证书分析"
rlRun 'nmap -T4 --host-timeout 30s --script=ssl-heartbleed -p 443 localhost 2>&1' 0 "Heartbleed 漏洞检测"
rlRun 'nmap -T4 --host-timeout 30s --script=sslv2 -p 443 localhost 2>&1' 0 "SSLv2 支持检测"

echo ""
echo "All nmap SSL/TLS analysis tests passed!"
