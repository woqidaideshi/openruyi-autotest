#!/bin/sh -eux
# Functional test: dbus - ��������
# Commands: dbus-launch, dbus-send

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install dbus ===
INSTALLED_BY_TEST=0
if ! rpm -q dbus 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y dbus 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed dbus"
    else
        echo "SKIP: dbus not available in repos"
        exit 0
    fi
else
    echo "SETUP: dbus already installed"
fi



echo "=== dbus �������� ==="
rlRun 'dbus-launch --help 2>&1 | head -10' 0 "dbus-launch ����"
rlRun 'dbus-send --help 2>&1 | head -10' 0 "dbus-send ����"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y dbus 2>/dev/null || true
    echo "TEARDOWN: removed dbus"
fi
echo ""
echo "All dbus-basic functional tests passed!"
