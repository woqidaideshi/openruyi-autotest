#!/bin/sh -eux
# Functional test: clang - Optimization-levels

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q clang 2>/dev/null || { echo 'clang not installed, skipping'; exit 0; }
which clang 2>/dev/null || echo 'clang not found'
which clang++ 2>/dev/null || echo 'clang++ not found'
which clang-cl 2>/dev/null || echo 'clang-cl not found'
which clang-cpp 2>/dev/null || echo 'clang-cpp not found'
which clang-scan-deps 2>/dev/null || echo 'clang-scan-deps not found'
rlRun 'clang --version' 0 "clang version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Optimization levels ==="
for lvl in O0 O1 O2 O3 Os Oz; do
    rlRun "clang -$lvl -c hello.c -o hello_$lvl.o" 0 "Optimization -$lvl"
done


echo ""
echo "All clang Optimization-levels tests passed!"
