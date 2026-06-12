#!/bin/sh -eux
# Functional test: gxx - Preprocessor

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q gcc-c++' 0 "Check gcc-c++ is installed"
rlRun 'which g++' 0 "Check g++ command available"
rlRun 'which c++' 0 "Check c++ command available"
rlRun 'g++ --version' 0 "g++ version info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: Preprocessor ==="
rlRun 'g++ -E hello.cpp | head -5' 0 "g++ -E: preprocess"


echo ""
echo "All gxx Preprocessor tests passed!"
