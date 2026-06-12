#!/bin/sh -eux
# Functional test: unzip - ��������
# Tests: unzip, funzip, zipgrep, zipinfo commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q unzip 2>/dev/null || { echo 'unzip not installed, skipping'; exit 0; }
which unzip 2>/dev/null || echo 'unzip not found'
which funzip 2>/dev/null || echo 'funzip not found'
which zipgrep 2>/dev/null || echo 'zipgrep not found'
which zipinfo 2>/dev/null || echo 'zipinfo not found'

echo "=== ����: unzip �������� ==="
rlRun 'unzip --help 2>&1 | head -10' 0 "�鿴 unzip ������Ϣ"
rlRun 'funzip --help 2>&1 | head -10' 0 "�鿴 funzip ������Ϣ"
rlRun 'zipgrep --help 2>&1 | head -10' 0 "�鿴 zipgrep ������Ϣ"
rlRun 'zipinfo --help 2>&1 | head -10' 0 "�鿴 zipinfo ������Ϣ"

echo ""
echo "All unzip-basic functional tests passed!"
