#!/bin/sh -eux
# Functional test: clang - Compile-only

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

echo "=== Test 3: Compile-only ==="
rlRun 'clang -c hello.c -o hello.o' 0 "clang -c: compile only"
rlRun 'test -f hello.o' 0 "Object file exists"


echo ""
echo "All clang Compile-only tests passed!"
