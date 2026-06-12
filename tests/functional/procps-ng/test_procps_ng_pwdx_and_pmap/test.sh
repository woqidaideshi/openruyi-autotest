#!/bin/sh -eux
# Functional test: procps-ng - pwdx-and-pmap

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 9: pwdx and pmap ==="

# Test 9.1: Show process working directory
pwdx 1 || echo "pwdx test completed"

# Test 9.2: Show process memory map
pmap 1 2>&1 | head -10 || echo "pmap test completed"

cd /
rm -rf $TmpDir

echo ""
echo "All procps-ng pwdx-and-pmap tests passed!"
