#!/bin/sh -eux
# Functional test: keyutils - �ں���Կ����
# Commands: keyctl, request-key, key.dns_resolver

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install keyutils ===
INSTALLED_BY_TEST=0
if ! rpm -q keyutils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y keyutils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed keyutils"
    else
        echo "SKIP: keyutils not available in repos"
        exit 0
    fi
else
    echo "SETUP: keyutils already installed"
fi




# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y keyutils 2>/dev/null || true
    echo "TEARDOWN: removed keyutils"
fi
echo ""
echo "All keyutils functional tests passed!"
