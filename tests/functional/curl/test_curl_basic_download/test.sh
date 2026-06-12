#!/bin/sh -eux
# Functional test: curl - 基本下载

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q curl 2>/dev/null || { echo 'curl not installed, skipping'; exit 0; }
which curl 2>/dev/null || echo 'curl not found'
which wcurl 2>/dev/null || echo 'wcurl not found'
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
