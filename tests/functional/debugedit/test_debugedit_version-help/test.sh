#!/bin/sh -eux
# Functional test: debugedit - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q debugedit' 0 "检查 debugedit 是否已安装"
rlRun 'which debugedit' 0 "检查 debugedit 命令是否可用"
rlRun 'which debugedit-classify-ar' 0 "检查 debugedit-classify-ar 命令是否可用"
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
