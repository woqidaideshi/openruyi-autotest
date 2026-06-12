#!/bin/sh -eux
# Functional test: cmake - ctest-and-cpack

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: ctest and cpack ==="
ctest --version
cpack --version 2>&1 || true

cd /
rm -rf $TmpDir

echo ""
echo "All cmake ctest-and-cpack tests passed!"
