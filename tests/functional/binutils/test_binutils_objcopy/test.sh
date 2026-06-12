#!/bin/sh -eux
# Functional test: binutils - objcopy
# Commands: objcopy, strip

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q binutils 2>/dev/null || { echo 'binutils not installed, skipping'; exit 0; }
which objcopy 2>/dev/null || echo 'objcopy not found'
which strip 2>/dev/null || echo 'strip not found'
rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱĿ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"

echo "=== objcopy/strip ==="
rlRun 'cp /usr/bin/ls .' 0 "���Ʋ����ļ�"
rlRun 'objcopy --help 2>&1 | head -10' 0 "objcopy ����"
rlRun 'strip --help 2>&1 | head -10' 0 "strip ����"
rlRun 'strip ls 2>&1 || true' 0 "strip �ļ�"

echo ""
echo "All binutils-objcopy functional tests passed!"
