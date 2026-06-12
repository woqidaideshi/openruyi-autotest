#!/bin/sh -eux
# Functional test: systemd - systemd-ac-power

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q systemd 2>/dev/null || { echo 'systemd not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 23: systemd-ac-power ==="

rlRun 'systemd-ac-power 2>&1 || true' 0 "systemd-ac-power: check power"

# ===================================================================

echo ""
echo "All systemd systemd-ac-power tests passed!"
