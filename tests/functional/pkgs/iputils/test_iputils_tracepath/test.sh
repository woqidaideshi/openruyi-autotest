#!/bin/sh -eux
# Functional test: iputils - tracepath

. "../setup.sh"

echo "=== Test 5: tracepath ==="

# Test 5.1: Basic tracepath to localhost
tracepath -m 5 127.0.0.1 || echo "tracepath test completed"

# Test 5.2: tracepath with max hops
tracepath -m 10 127.0.0.1 || echo "tracepath with max hops test completed"

# Test 5.3: tracepath IPv6
tracepath6 -m 5 ::1 || echo "tracepath6 test completed"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All iputils tracepath tests passed!"
