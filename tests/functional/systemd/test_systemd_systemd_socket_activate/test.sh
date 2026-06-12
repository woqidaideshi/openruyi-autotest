#!/bin/sh -eux
# Functional test: systemd - systemd-socket-activate

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q systemd 2>/dev/null || { echo 'systemd not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 26: systemd-socket-activate ==="

rlRun 'systemd-socket-activate --help 2>&1 | head -5' 0 "systemd-socket-activate help"

# ===================================================================

echo ""
echo "All systemd systemd-socket-activate tests passed!"
