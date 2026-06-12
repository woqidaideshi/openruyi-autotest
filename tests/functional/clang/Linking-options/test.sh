#!/bin/sh -eux
# Functional test: clang - Linking-options

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

echo "=== Test 13: Linking options ==="
rlRun 'clang -fPIC -c hello.c -o hello_pic.o' 0 "Compile with -fPIC"
rlRun 'clang -shared hello_pic.o -o libhello.so' 0 "clang -shared: shared library"


echo ""
echo "All clang Linking-options tests passed!"
