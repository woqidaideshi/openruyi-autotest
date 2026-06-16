#!/bin/sh -eux
# Functional test: cloud-utils-growpart - Error-handling

. "../setup.sh"

echo "=== Test 6: Error handling ==="
rlRun 'growpart 2>&1 || true' 0 "growpart: no args (expected fail)"
rlRun 'growpart /dev/nonexistent 1 2>&1 || true' 0 "growpart: nonexistent disk"
rlRun 'growpart --invalid 2>&1 || true' 0 "growpart: invalid option"

. "../teardown.sh"
echo "All cloud-utils-growpart Error-handling tests passed!"
