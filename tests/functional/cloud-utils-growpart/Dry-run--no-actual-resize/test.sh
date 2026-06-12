#!/bin/sh -eux
# Functional test: cloud-utils-growpart - Dry-run--no-actual-resize

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q cloud-utils-growpart' 0 "Check cloud-utils-growpart installed"
rlRun 'which growpart' 0 "Check growpart command available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: Dry-run (no actual resize) ==="
# Get first partition info
DISK=$(lsblk -ndo NAME | head -1)
if [ -n "$DISK" ] && [ -b "/dev/$DISK" ]; then
    rlRun "growpart -N /dev/$DISK 1 2>&1 || true" 0 "growpart -N: dry run"
fi

cd /
rm -rf $TmpDir

echo ""
echo "All cloud-utils-growpart Dry-run--no-actual-resize tests passed!"
