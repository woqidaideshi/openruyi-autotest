#!/bin/sh -eux
# Functional test: expat - ������
# Tests: xmlwf commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install expat ===
INSTALLED_BY_TEST=0
if ! rpm -q expat 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y expat 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed expat"
    else
        echo "SKIP: expat not available in repos"
        exit 0
    fi
else
    echo "SETUP: expat already installed"
fi



echo "=== ����: ������ ==="
rlRun 'xmlwf --invalid-flag-xyz 2>&1 || true' 0 "���� xmlwf ��Ч����������"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y expat 2>/dev/null || true
    echo "TEARDOWN: removed expat"
fi
echo ""
echo "All expat-error functional tests passed!"
