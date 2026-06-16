#!/bin/sh -eux
# Functional test: clang - clang-cpp

. "../setup.sh"

echo "=== Test 11: clang-cpp ==="
rlRun 'clang-cpp hello.c 2>&1 | head -10' 0 "clang-cpp: preprocessor"

. "../teardown.sh"
echo "All clang clang-cpp tests passed!"
