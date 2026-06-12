#!/bin/sh -eux
# Functional test: clang - clang-scan-deps

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

echo "=== Test 12: clang-scan-deps ==="
rlRun 'clang-scan-deps --help 2>&1 | head -5' 0 "clang-scan-deps help"


echo ""
echo "All clang clang-scan-deps tests passed!"
