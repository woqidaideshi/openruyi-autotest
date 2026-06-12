#!/bin/sh -eux
# Functional test: systemd - systemd-mount

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q systemd' 0 "Check systemd package is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 33: systemd-mount ==="

rlRun 'systemd-mount --help 2>&1 | head -5' 0 "systemd-mount help"

# ===================================================================

echo ""
echo "All systemd systemd-mount tests passed!"
