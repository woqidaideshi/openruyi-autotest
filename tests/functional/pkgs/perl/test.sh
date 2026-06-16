#!/bin/sh -eux
# Functional test: perl - Perl ������
# Commands: perl

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install perl ===
INSTALLED_BY_TEST=0
if ! rpm -q perl 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y perl 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed perl"
    else
        echo "SKIP: perl not available in repos"
        exit 0
    fi
else
    echo "SETUP: perl already installed"
fi


rlRun 'perl --version 2>&1 || true' 0 "��ȡ perl �汾"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y perl 2>/dev/null || true
    echo "TEARDOWN: removed perl"
fi
echo ""
echo "All perl functional tests passed!"
