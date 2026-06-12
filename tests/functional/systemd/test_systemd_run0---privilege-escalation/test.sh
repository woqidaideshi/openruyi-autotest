#!/bin/sh -eux
# Functional test: systemd - run0---Privilege-escalation

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q systemd' 0 "Check systemd package is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 32: run0 - Privilege escalation ==="

rlRun 'run0 --help 2>&1 | head -5' 0 "run0 help"

# ===================================================================

echo ""
echo "All systemd run0---Privilege-escalation tests passed!"
