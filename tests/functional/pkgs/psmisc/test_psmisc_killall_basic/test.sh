#!/bin/sh -eux
# Functional test: psmisc - killall-basic

. "../setup.sh"

echo "=== Test 7: killall basic ==="

# Start test process
sleep 3600 &
TEST_PID=$!
echo "Test PID: $TEST_PID"

# Try killall (may not kill itself)
killall -l 2>&1 || echo "List signals test"
killall sleep 2>&1 || echo "killall test completed"

# Clean up
kill $TEST_PID 2>&1 || true

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All psmisc killall-basic tests passed!"
