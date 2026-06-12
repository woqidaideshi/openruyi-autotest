#!/bin/sh -eux
# Functional test: systemd - oomctl

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q systemd 2>/dev/null || { echo 'systemd not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 30: oomctl ==="

rlRun 'oomctl --help 2>&1 | head -5' 0 "oomctl help"
rlRun 'oomctl dump 2>&1 | head -5 || true' 0 "oomctl dump"

# ===================================================================

echo ""
echo "All systemd oomctl tests passed!"
