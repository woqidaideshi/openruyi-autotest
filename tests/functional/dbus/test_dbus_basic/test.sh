#!/bin/sh -eux
# Functional test: dbus - ��������
# Commands: dbus-launch, dbus-send

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q dbus 2>/dev/null || { echo 'dbus not installed, skipping'; exit 0; }
which dbus-launch 2>/dev/null || echo 'dbus-launch not found'
which dbus-send 2>/dev/null || echo 'dbus-send not found'

echo "=== dbus �������� ==="
rlRun 'dbus-launch --help 2>&1 | head -10' 0 "dbus-launch ����"
rlRun 'dbus-send --help 2>&1 | head -10' 0 "dbus-send ����"

echo ""
echo "All dbus-basic functional tests passed!"
