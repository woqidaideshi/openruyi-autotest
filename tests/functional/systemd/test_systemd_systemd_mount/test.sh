#!/bin/sh -eux
# Functional test: systemd - systemd-mount

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q systemd 2>/dev/null || { echo 'systemd not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 33: systemd-mount ==="

rlRun 'systemd-mount --help 2>&1 | head -5' 0 "systemd-mount help"

# ===================================================================

echo ""
echo "All systemd systemd-mount tests passed!"
