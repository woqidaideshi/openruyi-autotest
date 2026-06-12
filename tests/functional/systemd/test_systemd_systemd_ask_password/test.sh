#!/bin/sh -eux
# Functional test: systemd - systemd-ask-password

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q systemd' 0 "Check systemd package is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 24: systemd-ask-password ==="

rlRun 'systemd-ask-password --help 2>&1 | head -3' 0 "systemd-ask-password help"

# ===================================================================

echo ""
echo "All systemd systemd-ask-password tests passed!"
