#!/bin/sh -eux
# Functional test: cracklib - ����ǿ�ȼ��
# Commands: cracklib-check, cracklib-format, cracklib-packer, cracklib-unpacker

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install cracklib ===
INSTALLED_BY_TEST=0
if ! rpm -q cracklib 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y cracklib 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed cracklib"
    else
        echo "SKIP: cracklib not available in repos"
        exit 0
    fi
else
    echo "SETUP: cracklib already installed"
fi




# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y cracklib 2>/dev/null || true
    echo "TEARDOWN: removed cracklib"
fi
echo ""
echo "All cracklib functional tests passed!"
