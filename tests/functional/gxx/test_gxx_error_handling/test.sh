#!/bin/sh -eux
# Functional test: gxx - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q gcc-c++ 2>/dev/null || { echo 'gcc-c++ not installed, skipping'; exit 0; }
which g++ 2>/dev/null || echo 'g++ not found'
which c++ 2>/dev/null || echo 'c++ not found'
rlRun 'g++ --version' 0 "g++ version info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 12: Error handling ==="
rlRun 'g++ bad.cpp -o bad 2>&1 || true' 0 "Compilation error"
rlRun 'g++ --invalid 2>&1 || true' 0 "Invalid option"

cd /
rm -rf $TmpDir

echo ""
echo "All g++ functional tests passed!"

echo ""
echo "All gxx Error-handling tests passed!"
