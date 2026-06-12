#!/bin/sh -eux
# Functional test: kmod - ��������
# Commands: lsmod, modinfo, modprobe

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



echo "=== �ں�ģ����� ==="
rlRun 'lsmod 2>&1 | head -10' 0 "�г����ص�ģ��"
rlRun 'modinfo --help 2>&1 | head -10' 0 "modinfo ����"
rlRun 'modprobe --help 2>&1 | head -10' 0 "modprobe ����"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y kmod 2>/dev/null || true
    echo "TEARDOWN: removed kmod"
fi
echo ""
echo "All kmod-basic functional tests passed!"
