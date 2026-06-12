#!/bin/sh -eux
# Functional test: clang - Compile-only

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

echo "=== Test 3: Compile-only ==="
rlRun 'clang -c hello.c -o hello.o' 0 "clang -c: compile only"
rlRun 'test -f hello.o' 0 "Object file exists"


echo ""
echo "All clang Compile-only tests passed!"
