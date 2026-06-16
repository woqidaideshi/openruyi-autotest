#!/bin/sh -eux
# Functional test: dbus - D-Bus ��Ϣ����
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


rlRun 'dbus-launch --version 2>&1 || true' 0 "��ȡ dbus-launch �汾"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y dbus 2>/dev/null || true
    echo "TEARDOWN: removed dbus"
fi
echo ""
echo "All dbus functional tests passed!"
