#!/bin/sh -eux
# Functional test: gxx - Linking

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q gcc-c++ 2>/dev/null || { echo 'gcc-c++ not installed, skipping'; exit 0; }
which g++ 2>/dev/null || echo 'g++ not found'
which c++ 2>/dev/null || echo 'c++ not found'
rlRun 'g++ --version' 0 "g++ version info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: Linking ==="
rlRun 'g++ hello.o -o hello_link' 0 "Link from object"
rlRun 'g++ -shared hello.o -o libhello.so' 0 "g++ -shared: shared library"


echo ""
echo "All gxx Linking tests passed!"
