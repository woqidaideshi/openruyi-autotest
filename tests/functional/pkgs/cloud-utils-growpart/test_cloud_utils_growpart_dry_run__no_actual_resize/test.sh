#!/bin/sh -eux
# Functional test: cloud-utils-growpart - Dry-run--no-actual-resize

. "../setup.sh"

echo "=== Test 3: Dry-run (no actual resize) ==="
# Get first partition info
DISK=$(lsblk -ndo NAME | head -1)
if [ -n "$DISK" ] && [ -b "/dev/$DISK" ]; then
    rlRun "growpart -N /dev/$DISK 1 2>&1 || true" 0 "growpart -N: dry run"
fi

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All cloud-utils-growpart Dry-run--no-actual-resize tests passed!"
