#!/bin/sh -eux
# Functional test: clang - clang-cl--MSVC-compat

. "../setup.sh"

echo "=== Test 10: clang-cl (MSVC compat) ==="
rlRun 'clang-cl --help 2>&1 | head -5' 0 "clang-cl help"

. "../teardown.sh"
echo "All clang clang-cl--MSVC-compat tests passed!"
