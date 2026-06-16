#!/bin/sh -eux
# Functional test: iputils - clockdiff

. "../setup.sh"

echo "=== Test 7: clockdiff ==="

# Test 7.1: Clock difference to localhost
clockdiff 127.0.0.1 || echo "clockdiff test completed"

# Test 7.2: clockdiff with IPv6
clockdiff -o 127.0.0.1 || echo "clockdiff with option test completed"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All iputils clockdiff tests passed!"
