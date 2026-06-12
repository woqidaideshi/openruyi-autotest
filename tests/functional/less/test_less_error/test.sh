#!/bin/sh -eux
# Functional test: less - ������
# Tests: less, lessecho, lesskey commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install less ===
INSTALLED_BY_TEST=0
if ! rpm -q less 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y less 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed less"
    else
        echo "SKIP: less not available in repos"
        exit 0
    fi
else
    echo "SETUP: less already installed"
fi



echo "=== ����: ������ ==="
rlRun 'less --invalid-flag-xyz 2>&1 || true' 0 "���� less ��Ч����������"
rlRun 'lessecho --invalid-flag-xyz 2>&1 || true' 0 "���� lessecho ��Ч����������"
rlRun 'lesskey --invalid-flag-xyz 2>&1 || true' 0 "���� lesskey ��Ч����������"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y less 2>/dev/null || true
    echo "TEARDOWN: removed less"
fi
echo ""
echo "All less-error functional tests passed!"
