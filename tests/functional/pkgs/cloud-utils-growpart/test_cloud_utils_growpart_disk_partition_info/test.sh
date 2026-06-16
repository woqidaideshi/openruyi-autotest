#!/bin/sh -eux
# Functional test: cloud-utils-growpart - Disk-partition-info

. "../setup.sh"

echo "=== Test 2: Disk/partition info ==="
rlRun 'lsblk 2>&1 | head -10' 0 "lsblk: list block devices"
rlRun 'df -h | head -10' 0 "df: disk free space"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All cloud-utils-growpart Disk-partition-info tests passed!"
