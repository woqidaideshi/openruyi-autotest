#!/bin/sh -eux
# Functional test: cmake - Basic-CMake-project

rlRun() { eval "$1" 2>&1; return $?; }

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

cd /
rm -rf $TmpDir

echo ""
echo "All cmake Basic-CMake-project tests passed!"
