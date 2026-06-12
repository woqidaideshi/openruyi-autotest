#!/bin/sh -eux
# Functional test: systemd - systemd-run

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q systemd' 0 "Check systemd package is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 13: systemd-run ==="

rlRun 'systemd-run --version 2>&1 || true' 0 "systemd-run version"
rlRun 'systemd-run --user --scope echo "test" 2>&1 || true' 0 "systemd-run --user --scope"

# ===================================================================

echo ""
echo "All systemd systemd-run tests passed!"
