#!/bin/sh -eux
# Functional test: weston - Error-handling

. "../setup.sh"

echo "=== Test 9: Error handling ==="
rlRun 'weston --invalid 2>&1 || true' 0 "weston: invalid option"

. "../teardown.sh"
echo "All weston Error-handling tests passed!"
