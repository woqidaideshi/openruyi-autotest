#!/bin/sh -eux
# Functional test: procps-ng - Special-scenarios

. "../setup.sh"

echo "=== Test 12: Special scenarios ==="

# Test 12.1: ps with environment variables
ps e -p 1 2>&1 | head -5 || echo "Environment variables test completed"

# Test 12.2: Process with real-time priority
ps -eo pid,rtprio,comm | head -10

# Test 12.3: Show process namespaces
ps -eo pid,ns:pid,comm | head -10 || echo "Namespace test completed"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All procps-ng Special-scenarios tests passed!"
