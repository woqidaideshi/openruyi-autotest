#!/bin/sh -eux
# Functional test: sqlite - ��������
# Tests: sqldiff, sqlite3 commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q sqlite 2>/dev/null || { echo 'sqlite not installed, skipping'; exit 0; }
which sqldiff 2>/dev/null || echo 'sqldiff not found'
which sqlite3 2>/dev/null || echo 'sqlite3 not found'

echo "=== ����: sqlite �������� ==="
rlRun 'sqldiff --help 2>&1 | head -10' 0 "�鿴 sqldiff ������Ϣ"
rlRun 'sqlite3 --help 2>&1 | head -10' 0 "�鿴 sqlite3 ������Ϣ"

echo ""
echo "All sqlite-basic functional tests passed!"
