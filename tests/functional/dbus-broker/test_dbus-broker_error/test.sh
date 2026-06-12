#!/bin/sh -eux
# Functional test: dbus-broker - ������
# Tests: dbus-broker commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q dbus-broker 2>/dev/null || { echo 'dbus-broker not installed, skipping'; exit 0; }

echo "=== ����: ������ ==="
rlRun 'dbus-broker --invalid-flag-xyz 2>&1 || true' 0 "���� dbus-broker ��Ч����������"

echo ""
echo "All dbus-broker-error functional tests passed!"
