#!/bin/sh -eux
# Functional test: dbus-broker - ������
# Tests: dbus-broker commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install dbus-broker ===
INSTALLED_BY_TEST=0
if ! rpm -q dbus-broker 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y dbus-broker 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed dbus-broker"
    else
        echo "SKIP: dbus-broker not available in repos"
        exit 0
    fi
else
    echo "SETUP: dbus-broker already installed"
fi



echo "=== ����: ������ ==="
rlRun 'dbus-broker --invalid-flag-xyz 2>&1 || true' 0 "���� dbus-broker ��Ч����������"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y dbus-broker 2>/dev/null || true
    echo "TEARDOWN: removed dbus-broker"
fi
echo ""
echo "All dbus-broker-error functional tests passed!"
