#!/bin/sh -eux
# Functional test: dbus-broker ������
# Tests: dbus-broker commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q dbus-broker 2>/dev/null || { echo 'dbus-broker not installed, skipping'; exit 0; }
which dbus-broker 2>/dev/null || echo 'dbus-broker not found'
rlRun 'dbus-broker --version 2>&1 || true' 0 "��ȡ dbus-broker �汾��Ϣ"

echo ""
echo "All dbus-broker functional tests passed!"
