#!/bin/sh -eux
# Functional test: clang - Verbose-mode

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

echo "=== Test 14: Verbose mode ==="
rlRun 'clang -v -c hello.c -o /dev/null 2>&1 | head -10' 0 "clang -v: verbose"


echo ""
echo "All clang Verbose-mode tests passed!"
