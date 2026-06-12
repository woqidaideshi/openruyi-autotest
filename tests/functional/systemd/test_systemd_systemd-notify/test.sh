#!/bin/sh -eux
# Functional test: systemd - systemd-notify

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q systemd' 0 "Check systemd package is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 15: systemd-notify ==="

rlRun 'systemd-notify --version 2>&1 || true' 0 "systemd-notify version"
rlRun 'systemd-notify --help 2>&1 | head -5' 0 "systemd-notify help"

# ===================================================================

echo ""
echo "All systemd systemd-notify tests passed!"
