#!/bin/sh -eux
# Functional test: cloud-utils-growpart - Disk-partition-info

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q cloud-utils-growpart' 0 "Check cloud-utils-growpart installed"
rlRun 'which growpart' 0 "Check growpart command available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 2: Disk/partition info ==="
rlRun 'lsblk 2>&1 | head -10' 0 "lsblk: list block devices"
rlRun 'df -h | head -10' 0 "df: disk free space"

cd /
rm -rf $TmpDir

echo ""
echo "All cloud-utils-growpart Disk-partition-info tests passed!"
