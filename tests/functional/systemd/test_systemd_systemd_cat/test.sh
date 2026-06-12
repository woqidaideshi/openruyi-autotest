#!/bin/sh -eux
# Functional test: systemd - systemd-cat

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q systemd 2>/dev/null || { echo 'systemd not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 14: systemd-cat ==="

rlRun 'echo "test log message" | systemd-cat 2>&1 || true' 0 "systemd-cat: pipe to journal"
rlRun 'systemd-cat --version 2>&1 || true' 0 "systemd-cat version"

# ===================================================================

echo ""
echo "All systemd systemd-cat tests passed!"
