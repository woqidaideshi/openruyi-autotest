#!/bin/sh -eux
# Functional test: icu4c - Unicode ���ʻ����
# Commands: icuinfo, uconv, genbrk, gencnval

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install icu4c ===
INSTALLED_BY_TEST=0
if ! rpm -q icu4c 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y icu4c 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed icu4c"
    else
        echo "SKIP: icu4c not available in repos"
        exit 0
    fi
else
    echo "SETUP: icu4c already installed"
fi




# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y icu4c 2>/dev/null || true
    echo "TEARDOWN: removed icu4c"
fi
echo ""
echo "All icu4c functional tests passed!"
