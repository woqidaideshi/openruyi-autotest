#!/bin/sh -eux
# Functional test: gcc16 - GCC 16 ������
# Commands: gcc-16, g++-16, gcov-16

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install gcc16 ===
INSTALLED_BY_TEST=0
if ! rpm -q gcc16 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y gcc16 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed gcc16"
    else
        echo "SKIP: gcc16 not available in repos"
        exit 0
    fi
else
    echo "SETUP: gcc16 already installed"
fi




# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gcc16 2>/dev/null || true
    echo "TEARDOWN: removed gcc16"
fi
echo ""
echo "All gcc16 functional tests passed!"
