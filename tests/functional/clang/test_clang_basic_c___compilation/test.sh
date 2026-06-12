#!/bin/sh -eux
# Functional test: clang - Basic-C---compilation

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

echo "=== Test 2: Basic C++ compilation ==="
rlRun 'clang++ -x c++ hello.c -o hello_cpp' 0 "Compile C++ from hello.c"
rlRun './hello_cpp' 0 "Run C++ binary"


echo ""
echo "All clang Basic-C---compilation tests passed!"
