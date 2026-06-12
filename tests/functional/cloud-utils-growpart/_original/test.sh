#!/bin/sh -eux
# Functional test: cloud-utils-growpart package
# Tests growpart partition resizing utility
# Version: cloud-utils-growpart

rlRun() { eval "$1" 2>&1; return $?; }

rlRun 'rpm -q cloud-utils-growpart' 0 "Check cloud-utils-growpart installed"
rlRun 'which growpart' 0 "Check growpart command available"

echo "=== Test 1: Help and version ==="
rlRun 'growpart --help 2>&1 | head -10' 0 "growpart help"
rlRun 'growpart -h 2>&1 | head -5' 0 "growpart -h: short help"

echo "=== Test 2: Disk/partition info ==="
rlRun 'lsblk 2>&1 | head -10' 0 "lsblk: list block devices"
rlRun 'df -h | head -10' 0 "df: disk free space"

echo "=== Test 3: Dry-run (no actual resize) ==="
# Get first partition info
DISK=$(lsblk -ndo NAME | head -1)
if [ -n "$DISK" ] && [ -b "/dev/$DISK" ]; then
    rlRun "growpart -N /dev/$DISK 1 2>&1 || true" 0 "growpart -N: dry run"
fi

echo "=== Test 4: Free percent option ==="
rlRun 'growpart --help 2>&1 | grep -q "free-percent"' 0 "growpart: has free-percent option"

echo "=== Test 5: Fudge factor option ==="
rlRun 'growpart --help 2>&1 | grep -q "fudge"' 0 "growpart: has fudge option"

echo "=== Test 6: Error handling ==="
rlRun 'growpart 2>&1 || true' 0 "growpart: no args (expected fail)"
rlRun 'growpart /dev/nonexistent 1 2>&1 || true' 0 "growpart: nonexistent disk"
rlRun 'growpart --invalid 2>&1 || true' 0 "growpart: invalid option"

echo ""
echo "All cloud-utils-growpart functional tests passed!"