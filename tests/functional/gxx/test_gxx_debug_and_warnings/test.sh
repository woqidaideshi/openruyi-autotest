#!/bin/sh -eux
# Functional test: gxx - Debug-and-warnings

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q gcc-c++ 2>/dev/null || { echo 'gcc-c++ not installed, skipping'; exit 0; }
which g++ 2>/dev/null || echo 'g++ not found'
which c++ 2>/dev/null || echo 'c++ not found'
rlRun 'g++ --version' 0 "g++ version info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 5: Debug and warnings ==="
rlRun 'g++ -g -c hello.cpp -o hello_g.o' 0 "Debug symbols"
rlRun 'g++ -Wall -c hello.cpp -o hello_Wall.o' 0 "-Wall warnings"
rlRun 'g++ -Wextra -c hello.cpp -o hello_Wextra.o' 0 "-Wextra warnings"


echo ""
echo "All gxx Debug-and-warnings tests passed!"
