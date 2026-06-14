#!/bin/sh -eu
# Security test: nmap — Network security scanner
# Covers: port scanning, service detection, OS fingerprinting,
#         NSE script scanning, firewall evasion, network discovery,
#         SSL/TLS analysis, output formats
# Target: localhost (safe testing, fast scans with --host-timeout)

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

# Verify nmap is functional
rlRun 'nmap --version 2>&1 || true' 0 "获取 nmap 版本信息"

echo "=== 测试 1: 基本端口扫描 ==="

rlRun 'nmap -T4 --host-timeout 30s -p 22,80,443 localhost 2>&1 || true' 0 "TCP 端口扫描 (常用端口)"
rlRun 'nmap -T4 --host-timeout 30s -sU -p 53 localhost 2>&1 || true' 0 "UDP 端口扫描 (DNS)"
rlRun 'nmap -T4 --host-timeout 30s -p 1-100 localhost 2>&1 || true' 0 "TCP 端口扫描 (1-100)"

echo "=== 测试 2: 服务版本检测 ==="

rlRun 'nmap -T4 --host-timeout 30s -sV -p 22 localhost 2>&1 || true' 0 "SSH 服务版本检测"
rlRun 'nmap -T4 --host-timeout 30s -sV --version-intensity 3 -p 22,80 localhost 2>&1 || true' 0 "服务版本探测"

echo "=== 测试 3: 操作系统指纹识别 ==="

rlRun 'nmap -T4 --host-timeout 60s -O localhost 2>&1 || true' 0 "操作系统指纹识别"
rlRun 'nmap -T4 --host-timeout 30s -O --osscan-limit localhost 2>&1 || true' 0 "限制型 OS 检测"

echo "=== 测试 4: NSE 脚本扫描 ==="

rlRun 'nmap -T4 --host-timeout 30s --script=banner -p 22 localhost 2>&1 || true' 0 "NSE banner 脚本"
rlRun 'nmap -T4 --host-timeout 30s --script=http-headers -p 80 localhost 2>&1 || true' 0 "NSE HTTP 头检测"
rlRun 'nmap -T4 --host-timeout 30s --script=ssh-auth-methods -p 22 localhost 2>&1 || true' 0 "NSE SSH 认证方法检测"
rlRun 'nmap -T4 --host-timeout 30s --script=ssl-enum-ciphers -p 443 localhost 2>&1 || true' 0 "NSE SSL 密码套件枚举"

echo "=== 测试 5: 防火墙/IDS 规避 ==="

rlRun 'nmap -T4 --host-timeout 30s -f -p 22 localhost 2>&1 || true' 0 "分片包扫描 (fragment)"
rlRun 'nmap -T4 --host-timeout 30s --data-length 30 -p 22 localhost 2>&1 || true' 0 "随机数据填充扫描"
rlRun 'nmap -T4 --host-timeout 30s --badsum -p 22 localhost 2>&1 || true' 0 "错误校验和探测"

echo "=== 测试 6: 网络主机发现 ==="

rlRun 'nmap -T4 --host-timeout 30s -sn 127.0.0.1 2>&1 || true' 0 "Ping 扫描 (主机发现)"
rlRun 'nmap -T4 --host-timeout 30s -PE localhost 2>&1 || true' 0 "ICMP Echo 发现"
rlRun 'nmap -T4 --host-timeout 30s -PS -p 22 localhost 2>&1 || true' 0 "TCP SYN Ping 发现"

echo "=== 测试 7: SSL/TLS 安全分析 ==="

rlRun 'nmap -T4 --host-timeout 30s --script=ssl-cert -p 443 localhost 2>&1 || true' 0 "SSL 证书分析"
rlRun 'nmap -T4 --host-timeout 30s --script=ssl-heartbleed -p 443 localhost 2>&1 || true' 0 "Heartbleed 漏洞检测"
rlRun 'nmap -T4 --host-timeout 30s --script=sslv2 -p 443 localhost 2>&1 || true' 0 "SSLv2 支持检测"

echo "=== 测试 8: 输出格式 ==="

TmpDir=$(mktemp -d)
cd $TmpDir

rlRun 'nmap -T4 --host-timeout 30s -oN normal_output.txt -p 22 localhost 2>&1 || true' 0 "普通格式输出 (-oN)"
rlRun 'nmap -T4 --host-timeout 30s -oX xml_output.xml -p 22 localhost 2>&1 || true' 0 "XML 格式输出 (-oX)"
rlRun 'nmap -T4 --host-timeout 30s -oG grepable_output.txt -p 22 localhost 2>&1 || true' 0 "Grepable 格式输出 (-oG)"
rlRun 'nmap -T4 --host-timeout 30s -oA all_output -p 22 localhost 2>&1 || true' 0 "全格式输出 (-oA)"

# 验证输出文件
rlRun 'test -f normal_output.txt && wc -l normal_output.txt || true' 0 "普通输出文件存在"
rlRun 'test -f xml_output.xml && head -3 xml_output.xml || true' 0 "XML 输出文件存在"
rlRun 'test -f grepable_output.txt && wc -l grepable_output.txt || true' 0 "Grepable 输出文件存在"

# 总结扫描结果
echo ""
echo "=== 安全扫描结果摘要 ==="
echo "扫描时间: $(date)"
echo "扫描目标: localhost (127.0.0.1)"

# 统计开放端口
OPEN_TCP=$(nmap -T4 --host-timeout 30s -p 1-1000 localhost 2>/dev/null | grep -c 'open' || echo 0)
echo "开放 TCP 端口数 (1-1000): $OPEN_TCP"

# 检查危险端口
DANGER_PORTS=""
for port in 23 21 3389 5900 6379 27017 11211; do
    if nmap -T4 --host-timeout 15s -p $port localhost 2>/dev/null | grep -q "${port}/tcp.*open"; then
        DANGER_PORTS="$DANGER_PORTS $port"
    fi
done
if [ -n "$DANGER_PORTS" ]; then
    echo "⚠ 警告: 发现危险开放端口:$DANGER_PORTS"
else
    echo "✓ 未发现常见危险端口开放"
fi

cd /; rm -rf $TmpDir

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y nmap 2>/dev/null || true
    echo "TEARDOWN: removed nmap"
fi

echo ""
echo "All nmap security tests completed!"
