#!/bin/sh -eux
# Functional test: clang - Linking-options

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

echo "=== Test 13: Linking options ==="
rlRun 'clang -fPIC -c hello.c -o hello_pic.o' 0 "Compile with -fPIC"
rlRun 'clang -shared hello_pic.o -o libhello.so' 0 "clang -shared: shared library"


echo ""
echo "All clang Linking-options tests passed!"
