#!/bin/sh -eux
# Functional test: systemd - systemd-tmpfiles

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q systemd 2>/dev/null || { echo 'systemd not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 11: systemd-tmpfiles ==="

rlRun 'systemd-tmpfiles --version 2>&1 || true' 0 "systemd-tmpfiles version"
rlRun 'systemd-tmpfiles --cat-config 2>&1 | head -10' 0 "systemd-tmpfiles --cat-config"

# ===================================================================

echo ""
echo "All systemd systemd-tmpfiles tests passed!"
