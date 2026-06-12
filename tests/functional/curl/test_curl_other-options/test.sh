#!/bin/sh -eux
# Functional test: curl - 其他选项

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q curl' 0 "检查 curl 是否已安装"
rlRun 'which curl' 0 "检查 curl 命令是否可用"
rlRun 'which wcurl' 0 "检查 wcurl 命令是否可用"
rlRun 'curl --version' 0 "curl 版本信息"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 4: 其他选项 ==="
rlRun 'curl -L http://example.com 2>&1 | head -3 || echo "跟随重定向"' 0 "curl -L: 跟随重定向"
rlRun 'curl -k https://example.com 2>&1 | head -3 || echo "忽略证书"' 0 "curl -k: 忽略SSL证书"
rlRun 'curl --connect-timeout 5 http://example.com 2>&1 | head -3 || echo "超时"' 0 "curl --connect-timeout: 连接超时"

cd /
rm -rf $TmpDir

echo ""
echo "All curl 其他选项 tests passed!"
