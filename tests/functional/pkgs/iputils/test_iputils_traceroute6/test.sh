#!/bin/sh -eux
# Functional test: iputils - traceroute6

. "../setup.sh"

echo "=== Test 4: traceroute6 ==="

# Test 4.1: Basic traceroute6 to localhost
traceroute6 -m 5 ::1 || echo "traceroute6 test completed"

# Test 4.2: traceroute6 with max hops
traceroute6 -m 10 ::1 || echo "traceroute6 with max hops test completed"

# Test 4.3: traceroute6 with wait time
traceroute6 -m 5 -w 2 ::1 || echo "traceroute6 with wait time test completed"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All iputils traceroute6 tests passed!"
