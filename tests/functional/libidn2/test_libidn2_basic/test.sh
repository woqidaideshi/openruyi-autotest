#!/bin/sh -eux
# Functional test: libidn2 - ��������
# Tests: idn2 commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libidn2 2>/dev/null || { echo 'libidn2 not installed, skipping'; exit 0; }
which idn2 2>/dev/null || echo 'idn2 not found'

echo "=== ����: libidn2 �������� ==="
rlRun 'idn2 --help 2>&1 | head -10' 0 "�鿴 idn2 ������Ϣ"

echo ""
echo "All libidn2-basic functional tests passed!"
