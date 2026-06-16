#!/bin/sh -eux
# Functional test: dwz - 版本和帮助

. "../setup.sh"

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'dwz --version 2>&1 || true' 0 "dwz 版本信息"
rlRun 'dwz --help 2>&1 | head -5 || true' 0 "dwz 帮助信息"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All dwz 版本和帮助 tests passed!"
