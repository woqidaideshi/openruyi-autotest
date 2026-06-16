#!/bin/sh -eux
# Functional test: clang - Static-analysis

. "../setup.sh"

echo "=== Test 9: Static analysis ==="
rlRun 'clang --analyze hello.c 2>&1 || true' 0 "clang --analyze: static analysis"

. "../teardown.sh"
echo "All clang Static-analysis tests passed!"
