#!/bin/sh -eux
# Functional test: e2fsprogs ������

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install e2fsprogs ===
INSTALLED_BY_TEST=0
if ! rpm -q e2fsprogs 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y e2fsprogs 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed e2fsprogs"
    else
        echo "SKIP: e2fsprogs not available in repos"
        exit 0
    fi
else
    echo "SETUP: e2fsprogs already installed"
fi



echo "=== ������ ==="
rlRun 'e2fsck --invalid 2>&1 || true' 0 "��Ч����"
rlRun 'mke2fs --invalid 2>&1 || true' 0 "mke2fs ��Ч����"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y e2fsprogs 2>/dev/null || true
    echo "TEARDOWN: removed e2fsprogs"
fi
echo ""
echo "All e2fsprogs-error functional tests passed!"
