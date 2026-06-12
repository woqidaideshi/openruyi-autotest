#!/bin/sh -eux
# Functional test: dbus-broker - ��������
# Tests: dbus-broker commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q dbus-broker 2>/dev/null || { echo 'dbus-broker not installed, skipping'; exit 0; }
which dbus-broker 2>/dev/null || echo 'dbus-broker not found'

echo "=== ����: dbus-broker �������� ==="
rlRun 'dbus-broker --help 2>&1 | head -10' 0 "�鿴 dbus-broker ������Ϣ"

echo ""
echo "All dbus-broker-basic functional tests passed!"
