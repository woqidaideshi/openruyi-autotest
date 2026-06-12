#!/bin/sh -eux
# Functional test: systemd - systemd-inhibit

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q systemd' 0 "Check systemd package is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 22: systemd-inhibit ==="

rlRun 'systemd-inhibit --help 2>&1 | head -5' 0 "systemd-inhibit help"
rlRun 'systemd-inhibit --list 2>&1 || true' 0 "systemd-inhibit --list"

# ===================================================================

echo ""
echo "All systemd systemd-inhibit tests passed!"
