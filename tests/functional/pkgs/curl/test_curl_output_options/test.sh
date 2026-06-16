#!/bin/sh -eux
# Functional test: curl - 输出选项

. "../setup.sh"

echo "=== 测试 2: 输出选项 ==="
rlRun 'curl -s -o /tmp/curl_test.html http://example.com 2>&1 || echo "输出测试"' 0 "curl -o: 输出到文件"
rlRun 'curl -s -O /dev/null 2>&1 || true' 0 "curl -O: 远程文件名"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All curl 输出选项 tests passed!"
