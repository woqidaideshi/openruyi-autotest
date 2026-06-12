#!/bin/sh -eux
# Functional test: gxx - c---alias

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q gcc-c++' 0 "Check gcc-c++ is installed"
rlRun 'which g++' 0 "Check g++ command available"
rlRun 'which c++' 0 "Check c++ command available"
rlRun 'g++ --version' 0 "g++ version info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 11: c++ alias ==="
rlRun 'c++ --version 2>&1 | head -1' 0 "c++ alias works"


echo ""
echo "All gxx c---alias tests passed!"
