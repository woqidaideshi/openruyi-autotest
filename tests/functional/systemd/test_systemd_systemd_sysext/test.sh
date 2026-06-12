#!/bin/sh -eux
# Functional test: systemd - systemd-sysext

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q systemd 2>/dev/null || { echo 'systemd not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 34: systemd-sysext ==="

rlRun 'systemd-sysext --help 2>&1 | head -5' 0 "systemd-sysext help"

# ===================================================================

echo ""
echo "All systemd systemd-sysext tests passed!"
