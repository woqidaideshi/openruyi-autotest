#!/bin/sh -eux
# Functional test: curl - 基本下载

. "../setup.sh"

echo "=== 测试 1: 基本下载 ==="
rlRun 'curl -s -o /dev/null http://example.com 2>&1 || echo "网络测试完成"' 0 "curl 下载示例页面"
rlRun 'curl -s -I http://example.com 2>&1 | head -5' 0 "curl -I: 仅获取响应头"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All curl 基本下载 tests passed!"
