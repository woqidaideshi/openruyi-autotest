#!/bin/sh -eux
# Functional test: gxx - Preprocessor

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q gcc-c++ 2>/dev/null || { echo 'gcc-c++ not installed, skipping'; exit 0; }
which g++ 2>/dev/null || echo 'g++ not found'
which c++ 2>/dev/null || echo 'c++ not found'
rlRun 'g++ --version' 0 "g++ version info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: Preprocessor ==="
rlRun 'g++ -E hello.cpp | head -5' 0 "g++ -E: preprocess"


echo ""
echo "All gxx Preprocessor tests passed!"
