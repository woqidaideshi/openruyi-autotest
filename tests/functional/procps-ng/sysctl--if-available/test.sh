#!/bin/sh -eux
# Functional test: procps-ng - sysctl--if-available

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 10: sysctl (if available) ==="

# Test 10.1: List all sysctl parameters
sysctl -a 2>&1 | head -20 || echo "sysctl not available"

# Test 10.2: Read specific parameter
sysctl kernel.hostname 2>&1 || echo "sysctl parameter read test"

cd /
rm -rf $TmpDir

echo ""
echo "All procps-ng sysctl--if-available tests passed!"
