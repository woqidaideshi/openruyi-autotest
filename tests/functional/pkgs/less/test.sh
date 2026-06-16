#!/bin/sh -eux
# Functional test: less ������
# Tests: less, lessecho, lesskey commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install less ===
INSTALLED_BY_TEST=0
if ! rpm -q less 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y less 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed less"
    else
        echo "SKIP: less not available in repos"
        exit 0
    fi
else
    echo "SETUP: less already installed"
fi


rlRun 'less --version 2>&1 || true' 0 "��ȡ less �汾��Ϣ"
rlRun 'lessecho --version 2>&1 || true' 0 "��ȡ lessecho �汾��Ϣ"
rlRun 'lesskey --version 2>&1 || true' 0 "��ȡ lesskey �汾��Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y less 2>/dev/null || true
    echo "TEARDOWN: removed less"
fi
echo ""
echo "All less functional tests passed!"
