#!/bin/sh -eux
# Functional test: clang - Optimization-levels

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q clang' 0 "Check clang installed"
rlRun 'which clang' 0 "Check clang available"
rlRun 'which clang++' 0 "Check clang++ available"
rlRun 'which clang-cl' 0 "Check clang-cl available"
rlRun 'which clang-cpp' 0 "Check clang-cpp available"
rlRun 'which clang-scan-deps' 0 "Check clang-scan-deps available"
rlRun 'clang --version' 0 "clang version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Optimization levels ==="
for lvl in O0 O1 O2 O3 Os Oz; do
    rlRun "clang -$lvl -c hello.c -o hello_$lvl.o" 0 "Optimization -$lvl"
done


echo ""
echo "All clang Optimization-levels tests passed!"
