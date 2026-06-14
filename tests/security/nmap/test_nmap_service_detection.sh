#!/bin/sh -eu
# Security test: nmap — Service version detection
# Tests service/version detection on open ports

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

# Verify nmap and service availability
rlRun 'nmap --version 2>&1' 0 "获取 nmap 版本信息"

# Check which ports are actually open on localhost
OPEN_PORTS=$(nmap -T4 --host-timeout 30s -p 22,80,443 localhost 2>/dev/null | awk '/open/ {print $1}' | cut -d/ -f1 | tr '\n' ' ' || true)
echo "Open ports on localhost: $OPEN_PORTS"

# At minimum, test service detection against whatever is open
TARGET_PORTS="${OPEN_PORTS:-22}"

echo "=== 测试: 服务版本检测 ==="

for port in $TARGET_PORTS; do
    rlRun "nmap -T4 --host-timeout 30s -sV -p $port localhost 2>&1" 0 "服务版本检测 (端口 $port)"
done

# Also test --version-intensity flag on first open port
FIRST_PORT=$(echo "$TARGET_PORTS" | awk '{print $1}')
rlRun "nmap -T4 --host-timeout 30s -sV --version-intensity 3 -p $FIRST_PORT localhost 2>&1" 0 "服务版本探测 (高强度)"

echo ""
echo "All nmap service detection tests passed!"
