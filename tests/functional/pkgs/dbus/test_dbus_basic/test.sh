#!/bin/sh -eux
# Functional test: dbus - ��������
# Commands: dbus-launch, dbus-send

. "../setup.sh"

echo "=== dbus �������� ==="
rlRun 'dbus-launch --help 2>&1 | head -10' 0 "dbus-launch ����"
rlRun 'dbus-send --help 2>&1 | head -10' 0 "dbus-send ����"

. "../teardown.sh"
echo "All dbus-basic functional tests passed!"
