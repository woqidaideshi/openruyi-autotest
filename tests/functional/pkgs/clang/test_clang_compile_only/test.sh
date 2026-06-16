#!/bin/sh -eux
# Functional test: clang - Compile-only

. "../setup.sh"

echo "=== Test 3: Compile-only ==="
rlRun 'clang -c hello.c -o hello.o' 0 "clang -c: compile only"
rlRun 'test -f hello.o' 0 "Object file exists"

. "../teardown.sh"
echo "All clang Compile-only tests passed!"
