#!/bin/sh -eux
# Functional test: iputils - ping-basic-functionality

. "../setup.sh"

echo "=== Test 1: ping basic functionality ==="

# Test 1.1: Ping localhost
ping -c 3 127.0.0.1

# Test 1.2: Ping with count limit
ping -c 5 127.0.0.1

# Test 1.3: Ping with interval
ping -c 3 -i 0.5 127.0.0.1

# Test 1.4: Ping with packet size
ping -c 3 -s 64 127.0.0.1
ping -c 3 -s 1024 127.0.0.1

# Test 1.5: Ping with timeout
ping -c 3 -W 2 127.0.0.1

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All iputils ping-basic-functionality tests passed!"
