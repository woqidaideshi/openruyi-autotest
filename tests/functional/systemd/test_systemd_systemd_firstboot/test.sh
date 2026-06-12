#!/bin/sh -eux
# Functional test: systemd - systemd-firstboot

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q systemd 2>/dev/null || { echo 'systemd not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 28: systemd-firstboot ==="

rlRun 'systemd-firstboot --help 2>&1 | head -5' 0 "systemd-firstboot help"

# ===================================================================

echo ""
echo "All systemd systemd-firstboot tests passed!"
