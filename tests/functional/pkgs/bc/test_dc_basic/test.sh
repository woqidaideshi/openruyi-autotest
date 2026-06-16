#!/bin/sh -eux
# Functional test: dc - �沨��������
# Tests: dc commands

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



echo "=== ����: dc �������� ==="
rlRun 'echo "1 1 + p" | dc' 0 "dc �ӷ�"
rlRun 'echo "10 3 - p" | dc' 0 "dc ����"
rlRun 'echo "6 7 * p" | dc' 0 "dc �˷�"
rlRun 'echo "100 3 / p" | dc' 0 "dc ����"
rlRun 'echo "4 k 1 3 / p" | dc' 0 "dc ��������"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y bc 2>/dev/null || true
    echo "TEARDOWN: removed bc"
fi
echo ""
echo "All dc-basic functional tests passed!"
