#!/bin/sh -eux
# Functional test: clang - Linking-options

. "../setup.sh"

echo "=== Test 13: Linking options ==="
rlRun 'clang -fPIC -c hello.c -o hello_pic.o' 0 "Compile with -fPIC"
rlRun 'clang -shared hello_pic.o -o libhello.so' 0 "clang -shared: shared library"

. "../teardown.sh"
echo "All clang Linking-options tests passed!"
