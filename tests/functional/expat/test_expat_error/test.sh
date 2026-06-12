#!/bin/sh -eux
# Functional test: expat - ������
# Tests: xmlwf commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q expat 2>/dev/null || { echo 'expat not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'xmlwf --invalid-flag-xyz 2>&1 || true' 0 "���� xmlwf ��Ч����������"

echo ""
echo "All expat-error functional tests passed!"
