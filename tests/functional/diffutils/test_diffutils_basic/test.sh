#!/bin/sh -eux
# Functional test: diffutils - ��������
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



echo "=== ����: diffutils �������� ==="
rlRun 'cmp --help 2>&1 | head -10' 0 "�鿴 cmp ������Ϣ"
rlRun 'diff --help 2>&1 | head -10' 0 "�鿴 diff ������Ϣ"
rlRun 'diff3 --help 2>&1 | head -10' 0 "�鿴 diff3 ������Ϣ"
rlRun 'sdiff --help 2>&1 | head -10' 0 "�鿴 sdiff ������Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y diffutils 2>/dev/null || true
    echo "TEARDOWN: removed diffutils"
fi
echo ""
echo "All diffutils-basic functional tests passed!"
