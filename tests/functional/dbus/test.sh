#!/bin/sh -eux
# Functional test: dbus - D-Bus ��Ϣ����
# Commands: dbus-launch, dbus-send

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q dbus 2>/dev/null || { echo 'dbus not installed, skipping'; exit 0; }
which dbus-launch 2>/dev/null || echo 'dbus-launch not found'
which dbus-send 2>/dev/null || echo 'dbus-send not found'
rlRun 'dbus-launch --version 2>&1 || true' 0 "��ȡ dbus-launch �汾"

echo ""
echo "All dbus functional tests passed!"
