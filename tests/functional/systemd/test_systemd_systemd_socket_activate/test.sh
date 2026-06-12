#!/bin/sh -eux
# Functional test: systemd - systemd-socket-activate

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q systemd' 0 "Check systemd package is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 26: systemd-socket-activate ==="

rlRun 'systemd-socket-activate --help 2>&1 | head -5' 0 "systemd-socket-activate help"

# ===================================================================

echo ""
echo "All systemd systemd-socket-activate tests passed!"
