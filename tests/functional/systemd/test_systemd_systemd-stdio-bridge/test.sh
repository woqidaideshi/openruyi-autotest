#!/bin/sh -eux
# Functional test: systemd - systemd-stdio-bridge

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q systemd' 0 "Check systemd package is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 29: systemd-stdio-bridge ==="

rlRun 'systemd-stdio-bridge --help 2>&1 | head -3' 0 "systemd-stdio-bridge help"

# ===================================================================

echo ""
echo "All systemd systemd-stdio-bridge tests passed!"
