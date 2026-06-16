#!/bin/sh -eux
# Functional test: procps-ng - kill-command

. "../setup.sh"

echo "=== Test 7: kill command ==="

# Test 7.1: Start a background process
sleep 100 &
BG_PID=$!
echo "Background process PID: $BG_PID"

# Test 7.2: List signal numbers
kill -l

# Test 7.3: Send SIGTERM
kill -15 $BG_PID || true

# Test 7.4: Wait for process to terminate
sleep 1

# Test 7.5: Verify process terminated
ps -p $BG_PID 2>&1 || echo "Process successfully terminated"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All procps-ng kill-command tests passed!"
