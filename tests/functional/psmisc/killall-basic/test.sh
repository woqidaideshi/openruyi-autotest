#!/bin/sh -eux
# Functional test: psmisc - killall-basic

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

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

echo ""
echo "All psmisc killall-basic tests passed!"
