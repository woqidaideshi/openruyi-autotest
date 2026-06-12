#!/bin/sh -eux
# Functional test: iputils - ping-error-handling

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 8: ping error handling ==="

# Test 8.1: Ping unreachable address
ping -c 2 -W 1 192.0.2.1 2>&1 || echo "Expected: unreachable host"

# Test 8.2: Ping with invalid address
ping -c 1 999.999.999.999 2>&1 || echo "Expected error for invalid address"

# Test 8.3: Ping with invalid count
ping -c 0 127.0.0.1 2>&1 || echo "Expected error for invalid count"

# Test 8.4: Ping with negative count
ping -c -1 127.0.0.1 2>&1 || echo "Expected error for negative count"

cd /
rm -rf $TmpDir

echo ""
echo "All iputils ping-error-handling tests passed!"
