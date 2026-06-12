#!/bin/sh -eux
# Functional test: gxx - Optimization

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q gcc-c++' 0 "Check gcc-c++ is installed"
rlRun 'which g++' 0 "Check g++ command available"
rlRun 'which c++' 0 "Check c++ command available"
rlRun 'g++ --version' 0 "g++ version info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: Optimization ==="
for lvl in O0 O1 O2; do
    rlRun "g++ -$lvl -c hello.cpp -o hello_$lvl.o" 0 "Optimization -$lvl"
done


echo ""
echo "All gxx Optimization tests passed!"
