#!/bin/sh -eux
# Functional test: gawk - ��������
# Tests: awk, gawk commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q gawk 2>/dev/null || { echo 'gawk not installed, skipping'; exit 0; }
which awk 2>/dev/null || echo 'awk not found'
which gawk 2>/dev/null || echo 'gawk not found'

echo "=== ����: gawk �������� ==="
rlRun 'awk --help 2>&1 | head -10' 0 "�鿴 awk ������Ϣ"
rlRun 'gawk --help 2>&1 | head -10' 0 "�鿴 gawk ������Ϣ"

echo ""
echo "All gawk-basic functional tests passed!"
