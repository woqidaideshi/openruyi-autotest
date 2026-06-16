#!/bin/sh -eux
# Functional test: procps-ng - vmstat-command

. "../setup.sh"

echo "=== Test 5: vmstat command ==="

# Test 5.1: Basic vmstat output
vmstat

# Test 5.2: vmstat with custom intervals
vmstat 1 2

# Test 5.3: vmstat with slabs info
vmstat -m | head -10

# Test 5.4: vmstat with disk stats
vmstat -d | head -10

# Test 5.5: vmstat with partitions
vmstat -p /dev/sda 2>&1 || echo "Expected: disk may not exist"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All procps-ng vmstat-command tests passed!"
