#!/bin/sh -eux
# Functional test: clang - clang-scan-deps

. "../setup.sh"

echo "=== Test 12: clang-scan-deps ==="
rlRun 'clang-scan-deps --help 2>&1 | head -5' 0 "clang-scan-deps help"

. "../teardown.sh"
echo "All clang clang-scan-deps tests passed!"
