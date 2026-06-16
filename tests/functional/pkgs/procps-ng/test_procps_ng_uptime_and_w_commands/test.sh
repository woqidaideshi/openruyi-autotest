#!/bin/sh -eux
# Functional test: procps-ng - uptime-and-w-commands

. "../setup.sh"

echo "=== Test 6: uptime and w commands ==="

# Test 6.1: System uptime
uptime

# Test 6.2: Show users
w | head -10

# Test 6.3: Show who is logged in
who

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All procps-ng uptime-and-w-commands tests passed!"
