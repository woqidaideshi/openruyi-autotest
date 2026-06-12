#!/bin/sh -eux
# Functional test: clang - Basic-C---compilation

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

echo "=== Test 2: Basic C++ compilation ==="
rlRun 'clang++ -x c++ hello.c -o hello_cpp' 0 "Compile C++ from hello.c"
rlRun './hello_cpp' 0 "Run C++ binary"


echo ""
echo "All clang Basic-C---compilation tests passed!"
