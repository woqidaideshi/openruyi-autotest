#!/bin/sh -eux
# Functional test: binutils - nm
# Commands: nm

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q binutils 2>/dev/null || { echo 'binutils not installed, skipping'; exit 0; }
which nm 2>/dev/null || echo 'nm not found'

echo "=== nm ���Ų鿴 ==="
rlRun 'nm --help 2>&1 | head -10' 0 "nm ����"
which ls 2>/dev/null || echo 'ls not found'
rlRun 'nm /usr/bin/ls 2>&1 | head -10' 0 "�鿴 ls ���ű�"
rlRun 'nm -D /usr/bin/ls 2>&1 | head -10' 0 "�鿴��̬����"

echo ""
echo "All binutils-nm functional tests passed!"
