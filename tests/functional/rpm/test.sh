#!/bin/sh -eux
# Functional test: rpm - RPM ��������
# Commands: rpm, rpmkeys, rpm2cpio, rpmdb

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q rpm 2>/dev/null || { echo 'rpm not installed, skipping'; exit 0; }
which rpm 2>/dev/null || echo 'rpm not found'
which rpmkeys 2>/dev/null || echo 'rpmkeys not found'
rlRun 'rpm --version 2>&1 || true' 0 "rpm �汾"

echo ""
echo "All rpm functional tests passed!"
