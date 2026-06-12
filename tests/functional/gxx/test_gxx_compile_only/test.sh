#!/bin/sh -eux
# Functional test: gxx - Compile-only

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q gcc-c++ 2>/dev/null || { echo 'gcc-c++ not installed, skipping'; exit 0; }
which g++ 2>/dev/null || echo 'g++ not found'
which c++ 2>/dev/null || echo 'c++ not found'
rlRun 'g++ --version' 0 "g++ version info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 2: Compile-only ==="
rlRun 'g++ -c hello.cpp -o hello.o' 0 "g++ -c: compile only"
rlRun 'test -f hello.o' 0 "Object file exists"


echo ""
echo "All gxx Compile-only tests passed!"
