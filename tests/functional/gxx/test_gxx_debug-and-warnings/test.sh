#!/bin/sh -eux
# Functional test: gxx - Debug-and-warnings

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q gcc-c++' 0 "Check gcc-c++ is installed"
rlRun 'which g++' 0 "Check g++ command available"
rlRun 'which c++' 0 "Check c++ command available"
rlRun 'g++ --version' 0 "g++ version info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 5: Debug and warnings ==="
rlRun 'g++ -g -c hello.cpp -o hello_g.o' 0 "Debug symbols"
rlRun 'g++ -Wall -c hello.cpp -o hello_Wall.o' 0 "-Wall warnings"
rlRun 'g++ -Wextra -c hello.cpp -o hello_Wextra.o' 0 "-Wextra warnings"


echo ""
echo "All gxx Debug-and-warnings tests passed!"
