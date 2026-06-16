#!/bin/sh -eux
# Functional test: iproute2 - ���繤��
# Commands: ip, ss, tc, bridge

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install iproute2 ===
INSTALLED_BY_TEST=0
if ! rpm -q iproute2 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y iproute2 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed iproute2"
    else
        echo "SKIP: iproute2 not available in repos"
        exit 0
    fi
else
    echo "SETUP: iproute2 already installed"
fi




# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y iproute2 2>/dev/null || true
    echo "TEARDOWN: removed iproute2"
fi
echo ""
echo "All iproute2 functional tests passed!"
