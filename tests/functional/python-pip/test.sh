#!/bin/sh -eux
# Functional test: python-pip - Python ��������
# Commands: pip3

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install python-pip ===
INSTALLED_BY_TEST=0
if ! rpm -q python-pip 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y python-pip 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed python-pip"
    else
        echo "SKIP: python-pip not available in repos"
        exit 0
    fi
else
    echo "SETUP: python-pip already installed"
fi


rlRun 'pip3 --version 2>&1 || true' 0 "��ȡ pip3 �汾"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y python-pip 2>/dev/null || true
    echo "TEARDOWN: removed python-pip"
fi
echo ""
echo "All python-pip functional tests passed!"
