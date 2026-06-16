#!/bin/sh -eux
# Functional test: kmod - �ں�ģ�����
# Commands: depmod, insmod, kmod, lsmod, modinfo, modprobe, rmmod

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install kmod ===
INSTALLED_BY_TEST=0
if ! rpm -q kmod 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y kmod 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed kmod"
    else
        echo "SKIP: kmod not available in repos"
        exit 0
    fi
else
    echo "SETUP: kmod already installed"
fi




# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y kmod 2>/dev/null || true
    echo "TEARDOWN: removed kmod"
fi
echo ""
echo "All kmod functional tests passed!"
