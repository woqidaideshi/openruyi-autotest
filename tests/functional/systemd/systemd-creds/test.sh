#!/bin/sh -eux
# Functional test: systemd - systemd-creds

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q systemd' 0 "Check systemd package is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 25: systemd-creds ==="

rlRun 'systemd-creds --help 2>&1 | head -5' 0 "systemd-creds help"

# ===================================================================

echo ""
echo "All systemd systemd-creds tests passed!"
