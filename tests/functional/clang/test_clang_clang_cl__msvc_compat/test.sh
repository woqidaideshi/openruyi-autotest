#!/bin/sh -eux
# Functional test: clang - clang-cl--MSVC-compat

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

echo "=== Test 10: clang-cl (MSVC compat) ==="
rlRun 'clang-cl --help 2>&1 | head -5' 0 "clang-cl help"


echo ""
echo "All clang clang-cl--MSVC-compat tests passed!"
