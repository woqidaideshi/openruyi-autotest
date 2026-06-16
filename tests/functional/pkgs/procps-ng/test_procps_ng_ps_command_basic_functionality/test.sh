#!/bin/sh -eux
# Functional test: procps-ng - ps-command-basic-functionality

. "../setup.sh"

echo "=== Test 1: ps command basic functionality ==="

# Test 1.1: Basic ps output
ps

# Test 1.2: ps with full format
ps -ef

# Test 1.3: ps with custom format
ps -eo pid,comm,stat,%cpu,%mem

# Test 1.4: ps showing all processes
ps aux

# Test 1.5: ps with tree view
ps axjf | head -20

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All procps-ng ps-command-basic-functionality tests passed!"
