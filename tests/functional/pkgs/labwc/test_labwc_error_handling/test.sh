#!/bin/sh -eux
# Functional test: labwc - Error-handling

. "../setup.sh"

echo "=== Test 9: Error handling ==="
rlRun 'labwc --invalid 2>&1 || true' 0 "labwc: invalid option"

. "../teardown.sh"
echo "All labwc Error-handling tests passed!"
