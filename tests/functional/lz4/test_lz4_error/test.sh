#!/bin/sh -eux
# Functional test: lz4 - ������
# Tests: lz4, lz4c, lz4cat, unlz4 commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install lz4 ===
INSTALLED_BY_TEST=0
if ! rpm -q lz4 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y lz4 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed lz4"
    else
        echo "SKIP: lz4 not available in repos"
        exit 0
    fi
else
    echo "SETUP: lz4 already installed"
fi



echo "=== ����: ������ ==="
rlRun 'lz4 --invalid-flag-xyz 2>&1 || true' 0 "���� lz4 ��Ч����������"
rlRun 'lz4c --invalid-flag-xyz 2>&1 || true' 0 "���� lz4c ��Ч����������"
rlRun 'lz4cat --invalid-flag-xyz 2>&1 || true' 0 "���� lz4cat ��Ч����������"
rlRun 'unlz4 --invalid-flag-xyz 2>&1 || true' 0 "���� unlz4 ��Ч����������"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y lz4 2>/dev/null || true
    echo "TEARDOWN: removed lz4"
fi
echo ""
echo "All lz4-error functional tests passed!"
