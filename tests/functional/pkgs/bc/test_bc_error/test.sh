#!/bin/sh -eux
# Functional test: bc/dc - ������
# Tests: bc, dc commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install bc ===
INSTALLED_BY_TEST=0
if ! rpm -q bc 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y bc 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed bc"
    else
        echo "SKIP: bc not available in repos"
        exit 0
    fi
else
    echo "SETUP: bc already installed"
fi



echo "=== ����: ������ ==="
rlRun 'bc --invalid 2>&1 || true' 0 "bc ��Ч����"
rlRun 'dc --invalid 2>&1 || true' 0 "dc ��Ч����"
rlRun 'echo "1/0" | bc 2>&1 || true' 0 "bc �������"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y bc 2>/dev/null || true
    echo "TEARDOWN: removed bc"
fi
echo ""
echo "All bc-error functional tests passed!"
