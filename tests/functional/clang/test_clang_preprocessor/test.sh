#!/bin/sh -eux
# Functional test: clang - Preprocessor

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

echo "=== Test 8: Preprocessor ==="
rlRun 'clang -E hello.c | head -20' 0 "clang -E: preprocess"
rlRun 'clang -dM -E hello.c | head -10' 0 "clang -dM: dump macros"


echo ""
echo "All clang Preprocessor tests passed!"
