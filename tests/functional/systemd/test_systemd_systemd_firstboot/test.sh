#!/bin/sh -eux
# Functional test: systemd - systemd-firstboot

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q systemd' 0 "Check systemd package is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 28: systemd-firstboot ==="

rlRun 'systemd-firstboot --help 2>&1 | head -5' 0 "systemd-firstboot help"

# ===================================================================

echo ""
echo "All systemd systemd-firstboot tests passed!"
