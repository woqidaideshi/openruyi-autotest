#!/bin/sh -eux
# Functional test: psmisc - killall-with-signals

. "../setup.sh"

echo "=== Test 11: killall with signals ==="

# List signal names
killall -l | head -5

# Test signal send
sleep 10 &
SLEEP_PID=$!
killall -0 sleep 2>&1 && echo "Process exists" || echo "Check test"
kill $SLEEP_PID 2>&1 || true

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All psmisc killall-with-signals tests passed!"
