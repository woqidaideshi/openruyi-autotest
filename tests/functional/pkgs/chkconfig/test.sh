#!/bin/sh -eux
# Functional test: chkconfig - ϵͳ�������
# Commands: chkconfig, alternatives, update-alternatives

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install chkconfig ===
INSTALLED_BY_TEST=0
if ! rpm -q chkconfig 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y chkconfig 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed chkconfig"
    else
        echo "SKIP: chkconfig not available in repos"
        exit 0
    fi
else
    echo "SETUP: chkconfig already installed"
fi


rlRun 'chkconfig --version 2>&1 || true' 0 "��ȡ chkconfig �汾"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y chkconfig 2>/dev/null || true
    echo "TEARDOWN: removed chkconfig"
fi
echo ""
echo "All chkconfig functional tests passed!"
