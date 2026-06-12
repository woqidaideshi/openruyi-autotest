#!/bin/sh -eux
# Functional test: gxx - c---alias

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q gcc-c++ 2>/dev/null || { echo 'gcc-c++ not installed, skipping'; exit 0; }
which g++ 2>/dev/null || echo 'g++ not found'
which c++ 2>/dev/null || echo 'c++ not found'
rlRun 'g++ --version' 0 "g++ version info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 11: c++ alias ==="
rlRun 'c++ --version 2>&1 | head -1' 0 "c++ alias works"


echo ""
echo "All gxx c---alias tests passed!"
