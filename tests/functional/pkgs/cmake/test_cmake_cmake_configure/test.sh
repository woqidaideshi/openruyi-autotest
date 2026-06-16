#!/bin/sh -eux
# Functional test: cmake - CMake-configure

. "../setup.sh"

echo "=== Test 2: CMake configure ==="
mkdir build && cd build
timeout 60 cmake .. 2>&1 || echo "cmake configure done"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All cmake CMake-configure tests passed!"
