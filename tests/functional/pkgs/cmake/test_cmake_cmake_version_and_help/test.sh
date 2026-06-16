#!/bin/sh -eux
# Functional test: cmake - CMake-version-and-help

. "../setup.sh"

echo "=== Test 6: CMake version and help ==="
cmake --version | grep "cmake version"
cmake --help | head -5
cpack --version 2>&1 || true

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All cmake CMake-version-and-help tests passed!"
