#!/bin/sh -eux
# Functional test: procps-ng - ps-command-advanced-features

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 2: ps command advanced features ==="

# Test 2.1: Filter by user
ps -u root | head -10

# Test 2.2: Filter by PID
ps -p 1

# Test 2.3: Show threads
ps -eLf | head -10

# Test 2.4: Process hierarchy
ps --forest | head -20

# Test 2.5: Sort by CPU usage
ps aux --sort=-%cpu | head -10

# Test 2.6: Sort by memory usage
ps aux --sort=-%mem | head -10

cd /
rm -rf $TmpDir

echo ""
echo "All procps-ng ps-command-advanced-features tests passed!"
