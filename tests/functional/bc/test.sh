#!/bin/sh -eux
# Functional test: bc - ���⾫�ȼ�����
# Tests: bc, dc commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install bc ===
INSTALLED_BY_TEST=0
if ! rpm -q bc 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y bc 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed bc"
    else
        echo "SKIP: bc not available in repos"
        exit 0
    fi
else
    echo "SETUP: bc already installed"
fi


rlRun 'bc --version' 0 "��ȡ bc �汾��Ϣ"
rlRun 'dc --version' 0 "��ȡ dc �汾��Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y bc 2>/dev/null || true
    echo "TEARDOWN: removed bc"
fi
echo ""
echo "All bc functional tests passed!"
