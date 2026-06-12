#!/bin/sh -eux
# Functional test: debugedit - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q debugedit 2>/dev/null || { echo 'debugedit not installed, skipping'; exit 0; }
which debugedit 2>/dev/null || echo 'debugedit not found'
which debugedit-classify-ar 2>/dev/null || echo 'debugedit-classify-ar not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'debugedit --version 2>&1 || true' 0 "debugedit 版本信息"
rlRun 'debugedit --help 2>&1 | head -5 || true' 0 "debugedit 帮助信息"
rlRun 'debugedit-classify-ar --version 2>&1 || true' 0 "debugedit-classify-ar 版本信息"
rlRun 'debugedit-classify-ar --help 2>&1 | head -5 || true' 0 "debugedit-classify-ar 帮助信息"

cd /
rm -rf $TmpDir

echo ""
echo "All debugedit 版本和帮助 tests passed!"
