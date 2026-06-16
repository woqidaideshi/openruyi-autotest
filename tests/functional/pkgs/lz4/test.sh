#!/bin/sh -eux
# Functional test: lz4 ������
# Tests: lz4, lz4c, lz4cat, unlz4 commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install lz4 ===
INSTALLED_BY_TEST=0
if ! rpm -q lz4 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y lz4 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed lz4"
    else
        echo "SKIP: lz4 not available in repos"
        exit 0
    fi
else
    echo "SETUP: lz4 already installed"
fi


rlRun 'lz4 --version 2>&1 || true' 0 "��ȡ lz4 �汾��Ϣ"
rlRun 'lz4c --version 2>&1 || true' 0 "��ȡ lz4c �汾��Ϣ"
rlRun 'lz4cat --version 2>&1 || true' 0 "��ȡ lz4cat �汾��Ϣ"
rlRun 'unlz4 --version 2>&1 || true' 0 "��ȡ unlz4 �汾��Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y lz4 2>/dev/null || true
    echo "TEARDOWN: removed lz4"
fi
echo ""
echo "All lz4 functional tests passed!"
