#!/bin/sh -eux
# Functional test: clang - Verbose-mode

. "../setup.sh"

echo "=== Test 14: Verbose mode ==="
rlRun 'clang -v -c hello.c -o /dev/null 2>&1 | head -10' 0 "clang -v: verbose"

. "../teardown.sh"
echo "All clang Verbose-mode tests passed!"
