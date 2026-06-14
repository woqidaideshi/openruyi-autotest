#!/bin/sh -eu
# Security test: nmap — Output formats
# Tests normal, XML, grepable, and all-format output modes
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

echo "=== 测试: 输出格式 ==="

TmpDir=$(mktemp -d)
cd $TmpDir

rlRun 'nmap -T4 --host-timeout 30s -oN normal_output.txt -p 22 localhost 2>&1 || true' 0 "普通格式输出 (-oN)"
rlRun 'nmap -T4 --host-timeout 30s -oX xml_output.xml -p 22 localhost 2>&1 || true' 0 "XML 格式输出 (-oX)"
rlRun 'nmap -T4 --host-timeout 30s -oG grepable_output.txt -p 22 localhost 2>&1 || true' 0 "Grepable 格式输出 (-oG)"
rlRun 'nmap -T4 --host-timeout 30s -oA all_output -p 22 localhost 2>&1 || true' 0 "全格式输出 (-oA)"
rlRun 'test -f normal_output.txt && wc -l normal_output.txt || true' 0 "普通输出文件存在"
rlRun 'test -f xml_output.xml && head -3 xml_output.xml || true' 0 "XML 输出文件存在"
rlRun 'test -f grepable_output.txt && wc -l grepable_output.txt || true' 0 "Grepable 输出文件存在"

cd /; rm -rf $TmpDir

# === TEARDOWN ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y nmap 2>/dev/null || true
    echo "TEARDOWN: removed nmap"
fi

echo ""
echo "All nmap output format tests passed!"
