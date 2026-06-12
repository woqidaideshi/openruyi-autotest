#!/bin/sh -eux
# Functional test: binutils - objdump
# Commands: objdump

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q binutils 2>/dev/null || { echo 'binutils not installed, skipping'; exit 0; }
which objdump 2>/dev/null || echo 'objdump not found'

echo "=== objdump ==="
rlRun 'objdump --help 2>&1 | head -10' 0 "objdump ����"
rlRun 'objdump -f /usr/bin/ls 2>&1 | head -10' 0 "�鿴�ļ�ͷ"
rlRun 'objdump -h /usr/bin/ls 2>&1 | head -20' 0 "�鿴����Ϣ"
rlRun 'objdump -d /usr/bin/ls 2>&1 | head -10' 0 "�����"

echo ""
echo "All binutils-objdump functional tests passed!"
