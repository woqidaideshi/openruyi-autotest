#!/bin/sh -eux
# Functional test: time - ��������
# Tests: time commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q time 2>/dev/null || { echo 'time not installed, skipping'; exit 0; }
which time 2>/dev/null || echo 'time not found'

echo "=== ����: time �������� ==="
rlRun 'time --help 2>&1 | head -10' 0 "�鿴 time ������Ϣ"

echo ""
echo "All time-basic functional tests passed!"
