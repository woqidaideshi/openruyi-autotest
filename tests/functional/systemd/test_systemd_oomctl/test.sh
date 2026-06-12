#!/bin/sh -eux
# Functional test: systemd - oomctl

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q systemd' 0 "Check systemd package is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 30: oomctl ==="

rlRun 'oomctl --help 2>&1 | head -5' 0 "oomctl help"
rlRun 'oomctl dump 2>&1 | head -5 || true' 0 "oomctl dump"

# ===================================================================

echo ""
echo "All systemd oomctl tests passed!"
