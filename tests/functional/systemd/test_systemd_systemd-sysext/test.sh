#!/bin/sh -eux
# Functional test: systemd - systemd-sysext

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q systemd' 0 "Check systemd package is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 34: systemd-sysext ==="

rlRun 'systemd-sysext --help 2>&1 | head -5' 0 "systemd-sysext help"

# ===================================================================

echo ""
echo "All systemd systemd-sysext tests passed!"
