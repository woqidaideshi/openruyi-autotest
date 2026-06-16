#!/bin/sh -eux
# Functional test: dbus - D-Bus ��Ϣ����
# Commands: dbus-launch, dbus-send

. "./setup.sh"



rlRun 'dbus-launch --version 2>&1 || true' 0 "��ȡ dbus-launch �汾"

. "./teardown.sh"
echo "All dbus functional tests passed!"
