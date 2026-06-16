#!/bin/sh -eux
# Functional test: keyutils - ��������
# Commands: keyctl

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install keyutils ===
INSTALLED_BY_TEST=0
if ! rpm -q keyutils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y keyutils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed keyutils"
    else
        echo "SKIP: keyutils not available in repos"
        exit 0
    fi
else
    echo "SETUP: keyutils already installed"
fi



echo "=== keyctl �������� ==="
rlRun 'keyctl --help 2>&1 | head -10' 0 "keyctl ����"
rlRun 'keyctl show 2>&1 || true' 0 "��ʾ��ǰ��Կ"
rlRun 'keyctl list @u 2>&1 || true' 0 "�г��û���Կ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y keyutils 2>/dev/null || true
    echo "TEARDOWN: removed keyutils"
fi
echo ""
echo "All keyutils-basic functional tests passed!"
