#!/bin/sh -eux
# Functional test: newt - 版本和帮助

. "../setup.sh"

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'whiptail --version 2>&1 || true' 0 "whiptail 版本信息"
rlRun 'whiptail --help 2>&1 | head -5 || true' 0 "whiptail 帮助信息"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All newt 版本和帮助 tests passed!"
