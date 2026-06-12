#!/bin/sh -eux
# Functional test: cmake - CMake-version-and-help

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: CMake version and help ==="
cmake --version | grep "cmake version"
cmake --help | head -5
cpack --version 2>&1 || true

cd /
rm -rf $TmpDir

echo ""
echo "All cmake functional tests passed!"
cd /
rm -rf $TmpDir

echo ""
echo "All cmake CMake-version-and-help tests passed!"
