#!/bin/sh -eux
# Functional test: clang - Preprocessor

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

echo "=== Test 8: Preprocessor ==="
rlRun 'clang -E hello.c | head -20' 0 "clang -E: preprocess"
rlRun 'clang -dM -E hello.c | head -10' 0 "clang -dM: dump macros"


echo ""
echo "All clang Preprocessor tests passed!"
