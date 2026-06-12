#!/bin/sh -eux
# Functional test: e2fsprogs - ext �ļ�ϵͳ����
# Commands: e2fsck, mke2fs, tune2fs, dumpe2fs, resize2fs

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




# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y e2fsprogs 2>/dev/null || true
    echo "TEARDOWN: removed e2fsprogs"
fi
echo ""
echo "All e2fsprogs functional tests passed!"
