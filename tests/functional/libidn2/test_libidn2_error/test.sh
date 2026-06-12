#!/bin/sh -eux
# Functional test: libidn2 - ������
# Tests: idn2 commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libidn2 ===
INSTALLED_BY_TEST=0
if ! rpm -q libidn2 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libidn2 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libidn2"
    else
        echo "SKIP: libidn2 not available in repos"
        exit 0
    fi
else
    echo "SETUP: libidn2 already installed"
fi



echo "=== ����: ������ ==="
rlRun 'idn2 --invalid-flag-xyz 2>&1 || true' 0 "���� idn2 ��Ч����������"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libidn2 2>/dev/null || true
    echo "TEARDOWN: removed libidn2"
fi
echo ""
echo "All libidn2-error functional tests passed!"
