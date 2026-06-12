#!/bin/sh -eux
# Functional test: systemd - systemd-path

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q systemd 2>/dev/null || { echo 'systemd not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 16: systemd-path ==="

rlRun 'systemd-path' 0 "systemd-path: all paths"
rlRun 'systemd-path systemd-system-config' 0 "systemd-path: specific path"
rlRun 'systemd-path --suffix=test search-bin' 0 "systemd-path --suffix"
rlRun 'systemd-path --help 2>&1 | head -3' 0 "systemd-path help"

# ===================================================================

echo ""
echo "All systemd systemd-path tests passed!"
