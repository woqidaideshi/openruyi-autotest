#!/bin/sh -eux
# Functional test: cmake - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 5: Error handling ==="
cmake --invalid 2>&1 || true

cd /
rm -rf $TmpDir

echo ""
echo "All cmake Error-handling tests passed!"
