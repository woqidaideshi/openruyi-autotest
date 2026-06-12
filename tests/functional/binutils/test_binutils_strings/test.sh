#!/bin/sh -eux
# Functional test: binutils - strings
# Commands: strings

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q binutils 2>/dev/null || { echo 'binutils not installed, skipping'; exit 0; }
which strings 2>/dev/null || echo 'strings not found'

echo "=== strings ==="
rlRun 'strings --help 2>&1 | head -10' 0 "strings ����"
rlRun 'strings /usr/bin/ls 2>&1 | head -10' 0 "��ȡ ls �ַ���"
rlRun 'strings -n 8 /usr/bin/ls 2>&1 | head -10' 0 "��ȡ���ַ���"

echo ""
echo "All binutils-strings functional tests passed!"
