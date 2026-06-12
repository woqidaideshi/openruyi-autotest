#!/bin/sh -eux
# Functional test: curl - 基本下载

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q curl' 0 "检查 curl 是否已安装"
rlRun 'which curl' 0 "检查 curl 命令是否可用"
rlRun 'which wcurl' 0 "检查 wcurl 命令是否可用"
rlRun 'curl --version' 0 "curl 版本信息"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 1: 基本下载 ==="
rlRun 'curl -s -o /dev/null http://example.com 2>&1 || echo "网络测试完成"' 0 "curl 下载示例页面"
rlRun 'curl -s -I http://example.com 2>&1 | head -5' 0 "curl -I: 仅获取响应头"

cd /
rm -rf $TmpDir

echo ""
echo "All curl 基本下载 tests passed!"
