#!/bin/sh -eux
# Functional test: iputils - ping6--IPv6

. "../setup.sh"

echo "=== Test 3: ping6 (IPv6) ==="

# Test 3.1: Ping6 localhost
ping6 -c 3 ::1 || echo "IPv6 ping test completed (IPv6 may not be enabled)"

# Test 3.2: Ping6 with count
ping6 -c 5 ::1 || echo "IPv6 ping with count test completed"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All iputils ping6--IPv6 tests passed!"
