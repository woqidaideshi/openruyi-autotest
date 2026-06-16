#!/bin/sh -eux
# Functional test: iputils - Network-interface-testing

. "../setup.sh"

echo "=== Test 10: Network interface testing ==="

# Test 10.1: Ping via specific interface
ping -c 3 -I lo 127.0.0.1

# Test 10.2: Multiple ping instances
ping -c 2 127.0.0.1 &
ping -c 2 127.0.0.1 &
wait || echo "Multiple ping instances test completed"

. "../teardown.sh"
echo "All iputils Network-interface-testing tests passed!"
