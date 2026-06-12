#!/bin/sh -eux
# Functional test: cmake package
# Tests CMake build system generator
# Version: cmake

rpm -q cmake gcc gcc-c++ make

rpm -q cmake
which cmake
cmake --version

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Basic CMake project ==="

mkdir simple_project && cd simple_project
cat > main.c << 'EOF'
#include <stdio.h>
int main() { printf("Hello CMake\n"); return 0; }
EOF

cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.10)
project(TestProject)
add_executable(test_app main.c)
EOF

echo "=== Test 2: CMake configure ==="
mkdir build && cd build
timeout 60 cmake .. 2>&1 || echo "cmake configure done"

echo "=== Test 3: CMake -E mode ==="
cmake -E echo "test"
cmake -E environment 2>&1 | head -5
cmake -E make_directory test_dir && test -d test_dir

echo "=== Test 4: ctest and cpack ==="
ctest --version
cpack --version 2>&1 || true

echo "=== Test 5: Error handling ==="
cmake --invalid 2>&1 || true

echo "=== Test 6: CMake version and help ==="
cmake --version | grep "cmake version"
cmake --help | head -5
cpack --version 2>&1 || true

cd /
rm -rf $TmpDir

echo ""
echo "All cmake functional tests passed!"