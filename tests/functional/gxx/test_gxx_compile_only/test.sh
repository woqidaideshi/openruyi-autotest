#!/bin/sh -eux
# Functional test: gxx - Compile-only

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q gcc-c++' 0 "Check gcc-c++ is installed"
rlRun 'which g++' 0 "Check g++ command available"
rlRun 'which c++' 0 "Check c++ command available"
rlRun 'g++ --version' 0 "g++ version info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 2: Compile-only ==="
rlRun 'g++ -c hello.cpp -o hello.o' 0 "g++ -c: compile only"
rlRun 'test -f hello.o' 0 "Object file exists"


echo ""
echo "All gxx Compile-only tests passed!"
