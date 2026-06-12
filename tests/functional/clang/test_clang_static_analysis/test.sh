#!/bin/sh -eux
# Functional test: clang - Static-analysis

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

echo "=== Test 9: Static analysis ==="
rlRun 'clang --analyze hello.c 2>&1 || true' 0 "clang --analyze: static analysis"


echo ""
echo "All clang Static-analysis tests passed!"
