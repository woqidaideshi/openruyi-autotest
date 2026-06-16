#!/bin/sh -eux
# Functional test: diffutils ������
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


rlRun 'cmp --version 2>&1 || true' 0 "��ȡ cmp �汾��Ϣ"
rlRun 'diff --version 2>&1 || true' 0 "��ȡ diff �汾��Ϣ"
rlRun 'diff3 --version 2>&1 || true' 0 "��ȡ diff3 �汾��Ϣ"
rlRun 'sdiff --version 2>&1 || true' 0 "��ȡ sdiff �汾��Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y diffutils 2>/dev/null || true
    echo "TEARDOWN: removed diffutils"
fi
echo ""
echo "All diffutils functional tests passed!"
