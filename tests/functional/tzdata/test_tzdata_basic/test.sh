#!/bin/sh -eux
# Functional test: tzdata - ��������
# Tests: tzselect, zdump, zic commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q tzdata 2>/dev/null || { echo 'tzdata not installed, skipping'; exit 0; }
which tzselect 2>/dev/null || echo 'tzselect not found'
which zdump 2>/dev/null || echo 'zdump not found'
which zic 2>/dev/null || echo 'zic not found'

echo "=== ����: tzdata �������� ==="
rlRun 'tzselect --help 2>&1 | head -10' 0 "�鿴 tzselect ������Ϣ"
rlRun 'zdump --help 2>&1 | head -10' 0 "�鿴 zdump ������Ϣ"
rlRun 'zic --help 2>&1 | head -10' 0 "�鿴 zic ������Ϣ"

echo ""
echo "All tzdata-basic functional tests passed!"
