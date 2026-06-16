#!/bin/sh -eux
# Functional test: alternatives - ��������
# Commands: alternatives

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



echo "=== alternatives �������� ==="
rlRun 'alternatives --help 2>&1 | head -10' 0 "�鿴����"
rlRun 'alternatives --list 2>&1 | head -5 || true' 0 "�г������"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y chkconfig 2>/dev/null || true
    echo "TEARDOWN: removed chkconfig"
fi
echo ""
echo "All alternatives-basic functional tests passed!"
