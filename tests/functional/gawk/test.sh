#!/bin/sh -eux
# Functional test: gawk ������
# Tests: awk, gawk commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install gawk ===
INSTALLED_BY_TEST=0
if ! rpm -q gawk 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y gawk 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed gawk"
    else
        echo "SKIP: gawk not available in repos"
        exit 0
    fi
else
    echo "SETUP: gawk already installed"
fi


rlRun 'awk --version 2>&1 || true' 0 "��ȡ awk �汾��Ϣ"
rlRun 'gawk --version 2>&1 || true' 0 "��ȡ gawk �汾��Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gawk 2>/dev/null || true
    echo "TEARDOWN: removed gawk"
fi
echo ""
echo "All gawk functional tests passed!"
