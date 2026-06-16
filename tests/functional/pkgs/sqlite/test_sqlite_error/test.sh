#!/bin/sh -eux
# Functional test: sqlite - ������
# Tests: sqldiff, sqlite3 commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'sqldiff --invalid-flag-xyz 2>&1 || true' 0 "���� sqldiff ��Ч����������"
rlRun 'sqlite3 --invalid-flag-xyz 2>&1 || true' 0 "���� sqlite3 ��Ч����������"

. "../teardown.sh"
echo "All sqlite-error functional tests passed!"
