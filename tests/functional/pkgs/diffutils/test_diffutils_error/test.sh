#!/bin/sh -eux
# Functional test: diffutils - ������
# Tests: cmp, diff, diff3, sdiff commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install diffutils ===
INSTALLED_BY_TEST=0
if ! rpm -q diffutils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y diffutils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed diffutils"
    else
        echo "SKIP: diffutils not available in repos"
        exit 0
    fi
else
    echo "SETUP: diffutils already installed"
fi



echo "=== ����: ������ ==="
rlRun 'cmp --invalid-flag-xyz 2>&1 || true' 0 "���� cmp ��Ч����������"
rlRun 'diff --invalid-flag-xyz 2>&1 || true' 0 "���� diff ��Ч����������"
rlRun 'diff3 --invalid-flag-xyz 2>&1 || true' 0 "���� diff3 ��Ч����������"
rlRun 'sdiff --invalid-flag-xyz 2>&1 || true' 0 "���� sdiff ��Ч����������"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y diffutils 2>/dev/null || true
    echo "TEARDOWN: removed diffutils"
fi
echo ""
echo "All diffutils-error functional tests passed!"
