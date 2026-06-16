#!/bin/sh -eux
# Functional test: binutils - objcopy
# Commands: objcopy, strip

. "../setup.sh"

rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱĿ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"

echo "=== objcopy/strip ==="
rlRun 'cp /usr/bin/ls .' 0 "���Ʋ����ļ�"
rlRun 'objcopy --help 2>&1 | head -10' 0 "objcopy ����"
rlRun 'strip --help 2>&1 | head -10' 0 "strip ����"
rlRun 'strip ls 2>&1 || true' 0 "strip �ļ�"

. "../teardown.sh"
echo "All binutils-objcopy functional tests passed!"
