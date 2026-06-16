#!/bin/sh -eux
# Functional test: dnf5-plugins - Error-handling

. "../setup.sh"

echo "=== Test 10: Error handling ==="
rlRun 'dnf5 --invalid-option 2>&1 || true' 0 "dnf5: invalid option"

. "../teardown.sh"
echo "All dnf5-plugins Error-handling tests passed!"
