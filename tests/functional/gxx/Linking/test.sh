#!/bin/sh -eux
# Functional test: gxx - Linking

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q gcc-c++' 0 "Check gcc-c++ is installed"
rlRun 'which g++' 0 "Check g++ command available"
rlRun 'which c++' 0 "Check c++ command available"
rlRun 'g++ --version' 0 "g++ version info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: Linking ==="
rlRun 'g++ hello.o -o hello_link' 0 "Link from object"
rlRun 'g++ -shared hello.o -o libhello.so' 0 "g++ -shared: shared library"


echo ""
echo "All gxx Linking tests passed!"
