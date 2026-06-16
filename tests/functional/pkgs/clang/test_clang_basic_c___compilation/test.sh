#!/bin/sh -eux
# Functional test: clang - Basic-C---compilation

. "../setup.sh"

echo "=== Test 2: Basic C++ compilation ==="
rlRun 'clang++ -x c++ hello.c -o hello_cpp' 0 "Compile C++ from hello.c"
rlRun './hello_cpp' 0 "Run C++ binary"

. "../teardown.sh"
echo "All clang Basic-C---compilation tests passed!"
