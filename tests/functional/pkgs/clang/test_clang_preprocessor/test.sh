#!/bin/sh -eux
# Functional test: clang - Preprocessor

. "../setup.sh"

echo "=== Test 8: Preprocessor ==="
rlRun 'clang -E hello.c | head -20' 0 "clang -E: preprocess"
rlRun 'clang -dM -E hello.c | head -10' 0 "clang -dM: dump macros"

. "../teardown.sh"
echo "All clang Preprocessor tests passed!"
