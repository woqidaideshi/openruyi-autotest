#!/bin/sh -eux
# Functional test: gxx - Optimization

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q gcc-c++ 2>/dev/null || { echo 'gcc-c++ not installed, skipping'; exit 0; }
which g++ 2>/dev/null || echo 'g++ not found'
which c++ 2>/dev/null || echo 'c++ not found'
rlRun 'g++ --version' 0 "g++ version info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: Optimization ==="
for lvl in O0 O1 O2; do
    rlRun "g++ -$lvl -c hello.cpp -o hello_$lvl.o" 0 "Optimization -$lvl"
done


echo ""
echo "All gxx Optimization tests passed!"
