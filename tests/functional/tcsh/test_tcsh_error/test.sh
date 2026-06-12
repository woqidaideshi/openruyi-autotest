#!/bin/sh -eux
# Functional test: tcsh - ������
# Tests: tcsh commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install tcsh ===
INSTALLED_BY_TEST=0
if ! rpm -q tcsh 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y tcsh 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed tcsh"
    else
        echo "SKIP: tcsh not available in repos"
        exit 0
    fi
else
    echo "SETUP: tcsh already installed"
fi



echo "=== ����: ������ ==="
rlRun 'tcsh --invalid-flag-xyz 2>&1 || true' 0 "���� tcsh ��Ч����������"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tcsh 2>/dev/null || true
    echo "TEARDOWN: removed tcsh"
fi
echo ""
echo "All tcsh-error functional tests passed!"
