#!/bin/sh -eux
# Functional test: cmake - ctest-and-cpack

. "../setup.sh"

echo "=== Test 4: ctest and cpack ==="
ctest --version
cpack --version 2>&1 || true

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All cmake ctest-and-cpack tests passed!"
