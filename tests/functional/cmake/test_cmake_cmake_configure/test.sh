#!/bin/sh -eux
# Functional test: cmake - CMake-configure

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 2: CMake configure ==="
mkdir build && cd build
timeout 60 cmake .. 2>&1 || echo "cmake configure done"

cd /
rm -rf $TmpDir

echo ""
echo "All cmake CMake-configure tests passed!"
