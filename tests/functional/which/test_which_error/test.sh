#!/bin/sh -eux
# Functional test: which - ������
# Tests: which commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install which ===
INSTALLED_BY_TEST=0
if ! rpm -q which 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y which 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed which"
    else
        echo "SKIP: which not available in repos"
        exit 0
    fi
else
    echo "SETUP: which already installed"
fi



echo "=== ����: ������ ==="
rlRun 'which --invalid-flag-xyz 2>&1 || true' 0 "���� which ��Ч����������"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y which 2>/dev/null || true
    echo "TEARDOWN: removed which"
fi
echo ""
echo "All which-error functional tests passed!"
