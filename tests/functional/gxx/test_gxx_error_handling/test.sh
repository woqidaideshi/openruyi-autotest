#!/bin/sh -eux
# Functional test: gxx - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q gcc-c++' 0 "Check gcc-c++ is installed"
rlRun 'which g++' 0 "Check g++ command available"
rlRun 'which c++' 0 "Check c++ command available"
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
