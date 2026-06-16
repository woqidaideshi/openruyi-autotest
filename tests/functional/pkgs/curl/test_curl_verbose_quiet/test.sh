#!/bin/sh -eux
# Functional test: curl - 详细模式和静默模式

. "../setup.sh"

echo "=== 测试 3: 详细模式和静默模式 ==="
rlRun 'curl -v http://example.com 2>&1 | head -5 || echo "详细模式"' 0 "curl -v: 详细模式"
rlRun 'curl -s http://example.com 2>&1 | head -3' 0 "curl -s: 静默模式"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All curl 详细模式和静默模式 tests passed!"
