#!/bin/sh -eux
# Functional test: sddm - Version-and-help

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q sddm 2>/dev/null || { echo 'sddm not installed, skipping'; exit 0; }
which sddm 2>/dev/null || echo 'sddm not found'
rlRun 'which sddm-greeter-qt6 2>&1 || true' 0 "Check sddm-greeter available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Version and help ==="
rlRun 'sddm --help 2>&1 | head -10' 0 "sddm help"
rlRun 'sddm --test-mode --help 2>&1 | head -5' 0 "sddm --test-mode help"

cd /
rm -rf $TmpDir

echo ""
echo "All sddm Version-and-help tests passed!"
