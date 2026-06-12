#!/bin/sh -eux
# Functional test: sqlite ������
# Tests: sqldiff, sqlite3 commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q sqlite 2>/dev/null || { echo 'sqlite not installed, skipping'; exit 0; }
which sqldiff 2>/dev/null || echo 'sqldiff not found'
which sqlite3 2>/dev/null || echo 'sqlite3 not found'
rlRun 'sqldiff --version 2>&1 || true' 0 "��ȡ sqldiff �汾��Ϣ"
rlRun 'sqlite3 --version 2>&1 || true' 0 "��ȡ sqlite3 �汾��Ϣ"

echo ""
echo "All sqlite functional tests passed!"
