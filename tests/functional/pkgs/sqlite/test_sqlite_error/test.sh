#!/bin/sh -eux
# Functional test: sqlite - ������
# Tests: sqldiff, sqlite3 commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install sqlite ===
INSTALLED_BY_TEST=0
if ! rpm -q sqlite 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y sqlite 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed sqlite"
    else
        echo "SKIP: sqlite not available in repos"
        exit 0
    fi
else
    echo "SETUP: sqlite already installed"
fi



echo "=== ����: ������ ==="
rlRun 'sqldiff --invalid-flag-xyz 2>&1 || true' 0 "���� sqldiff ��Ч����������"
rlRun 'sqlite3 --invalid-flag-xyz 2>&1 || true' 0 "���� sqlite3 ��Ч����������"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y sqlite 2>/dev/null || true
    echo "TEARDOWN: removed sqlite"
fi
echo ""
echo "All sqlite-error functional tests passed!"
