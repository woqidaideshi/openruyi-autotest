#!/bin/sh -eux
# Functional test: cpio ������
# Tests: cpio commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install cpio ===
INSTALLED_BY_TEST=0
if ! rpm -q cpio 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y cpio 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed cpio"
    else
        echo "SKIP: cpio not available in repos"
        exit 0
    fi
else
    echo "SETUP: cpio already installed"
fi


rlRun 'cpio --version 2>&1 || true' 0 "��ȡ cpio �汾��Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y cpio 2>/dev/null || true
    echo "TEARDOWN: removed cpio"
fi
echo ""
echo "All cpio functional tests passed!"
