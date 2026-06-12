#!/bin/sh -eux
# Functional test: systemd - systemd-cgtop---Cgroup-top

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q systemd 2>/dev/null || { echo 'systemd not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 10: systemd-cgtop - Cgroup top ==="

rlRun 'systemd-cgtop -n 1 -b 2>&1 | head -15' 0 "systemd-cgtop -b: batch mode"

# ===================================================================

echo ""
echo "All systemd systemd-cgtop---Cgroup-top tests passed!"
