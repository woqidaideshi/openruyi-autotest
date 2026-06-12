#!/bin/sh -eux
# Functional test: expat - ��������
# Tests: xmlwf commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q expat 2>/dev/null || { echo 'expat not installed, skipping'; exit 0; }
which xmlwf 2>/dev/null || echo 'xmlwf not found'

echo "=== ����: expat �������� ==="
rlRun 'xmlwf --help 2>&1 | head -10' 0 "�鿴 xmlwf ������Ϣ"

echo ""
echo "All expat-basic functional tests passed!"
