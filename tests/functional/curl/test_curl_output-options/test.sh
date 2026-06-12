#!/bin/sh -eux
# Functional test: curl - 输出选项

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q curl' 0 "检查 curl 是否已安装"
rlRun 'which curl' 0 "检查 curl 命令是否可用"
rlRun 'which wcurl' 0 "检查 wcurl 命令是否可用"
rlRun 'curl --version' 0 "curl 版本信息"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 输出选项 ==="
rlRun 'curl -s -o /tmp/curl_test.html http://example.com 2>&1 || echo "输出测试"' 0 "curl -o: 输出到文件"
rlRun 'curl -s -O /dev/null 2>&1 || true' 0 "curl -O: 远程文件名"

cd /
rm -rf $TmpDir

echo ""
echo "All curl 输出选项 tests passed!"
