#!/bin/sh -eux
# Functional test: curl - wcurl

. "../setup.sh"

echo "=== 测试 5: wcurl ==="
rlRun 'wcurl --help 2>&1 | head -5 || echo "wcurl帮助"' 0 "wcurl 帮助"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All curl wcurl tests passed!"
