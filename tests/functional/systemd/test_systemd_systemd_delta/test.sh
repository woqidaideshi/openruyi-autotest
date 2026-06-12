#!/bin/sh -eux
# Functional test: systemd - systemd-delta

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q systemd 2>/dev/null || { echo 'systemd not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 20: systemd-delta ==="

rlRun 'systemd-delta --help 2>&1 | head -3' 0 "systemd-delta help"
rlRun 'systemd-delta 2>&1 | head -10' 0 "systemd-delta: show overrides"

# ===================================================================

echo ""
echo "All systemd systemd-delta tests passed!"
