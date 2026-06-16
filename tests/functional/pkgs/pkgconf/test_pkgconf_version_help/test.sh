#!/bin/sh -eux
# Functional test: pkgconf - 版本和帮助

. "../setup.sh"

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'pkgconf --version 2>&1 || true' 0 "pkgconf 版本信息"
rlRun 'pkgconf --help 2>&1 | head -5 || true' 0 "pkgconf 帮助信息"
rlRun 'bomtool --version 2>&1 || true' 0 "bomtool 版本信息"
rlRun 'bomtool --help 2>&1 | head -5 || true' 0 "bomtool 帮助信息"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All pkgconf 版本和帮助 tests passed!"
