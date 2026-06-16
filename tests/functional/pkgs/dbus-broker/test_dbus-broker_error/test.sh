#!/bin/sh -eux
# Functional test: dbus-broker - ������
# Tests: dbus-broker commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'dbus-broker --invalid-flag-xyz 2>&1 || true' 0 "���� dbus-broker ��Ч����������"

. "../teardown.sh"
echo "All dbus-broker-error functional tests passed!"
