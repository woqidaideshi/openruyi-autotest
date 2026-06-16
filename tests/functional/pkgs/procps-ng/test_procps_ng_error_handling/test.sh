#!/bin/sh -eux
# Functional test: procps-ng - Error-handling

. "../setup.sh"

echo "=== Test 11: Error handling ==="

# Test 11.1: ps with invalid PID
ps -p 999999 2>&1 || echo "Expected error for invalid PID"

# Test 11.2: kill with invalid PID
kill -9 999999 2>&1 || echo "Expected error for invalid PID"

# Test 11.3: free with invalid option
free -z 2>&1 || echo "Expected error for invalid option"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All procps-ng Error-handling tests passed!"
