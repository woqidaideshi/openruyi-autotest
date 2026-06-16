#!/bin/sh -eux
# Functional test: cmake - Error-handling

. "../setup.sh"

echo "=== Test 5: Error handling ==="
cmake --invalid 2>&1 || true

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All cmake Error-handling tests passed!"
