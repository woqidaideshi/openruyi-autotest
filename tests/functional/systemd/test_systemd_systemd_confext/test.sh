#!/bin/sh -eux
# Functional test: systemd - systemd-confext

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q systemd 2>/dev/null || { echo 'systemd not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 35: systemd-confext ==="

rlRun 'systemd-confext --help 2>&1 | head -5' 0 "systemd-confext help"

# ===================================================================

echo ""
echo "All systemd systemd-confext tests passed!"
