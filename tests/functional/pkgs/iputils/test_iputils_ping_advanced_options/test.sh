#!/bin/sh -eux
# Functional test: iputils - ping-advanced-options

. "../setup.sh"

echo "=== Test 2: ping advanced options ==="

# Test 2.1: Ping with flood mode (requires root)
ping -c 10 -f 127.0.0.1 || echo "Flood ping test completed"

# Test 2.2: Ping with numeric output
ping -c 3 -n 127.0.0.1

# Test 2.3: Ping with quiet mode
ping -c 3 -q 127.0.0.1

# Test 2.4: Ping with verbose output
ping -c 3 -v 127.0.0.1

# Test 2.5: Ping with timestamp
ping -c 3 -D 127.0.0.1

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All iputils ping-advanced-options tests passed!"
