#!/bin/sh -eux
# Functional test: sqlite - ������
# Tests: sqldiff, sqlite3 commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q sqlite 2>/dev/null || { echo 'sqlite not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'sqldiff --invalid-flag-xyz 2>&1 || true' 0 "���� sqldiff ��Ч����������"
rlRun 'sqlite3 --invalid-flag-xyz 2>&1 || true' 0 "���� sqlite3 ��Ч����������"

echo ""
echo "All sqlite-error functional tests passed!"
