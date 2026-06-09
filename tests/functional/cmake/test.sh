#!/bin/sh -eux
# Functional test: cmake package
# Tests CMake build system generator
# Version: cmake

rpm -q cmake || sudo dnf install -y cmake gcc gcc-c++ make

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
cmake ..

echo "=== Test 3: CMake build ==="

cmake --build .
./test_app
cd ../..

echo "=== Test 4: CMake options ==="

# Build type
mkdir build_debug && cd build_debug
cmake -DCMAKE_BUILD_TYPE=Debug ../simple_project
cmake --build .
cd ..

# Install prefix
mkdir build_prefix && cd build_prefix
cmake -DCMAKE_INSTALL_PREFIX=/tmp/cmake_test ../simple_project
cmake --build .
cd ..

echo "=== Test 5: Library project ==="

mkdir lib_project && cd lib_project
cat > mylib.c << 'EOF'
int add(int a, int b) { return a + b; }
EOF
cat > mylib.h << 'EOF'
int add(int a, int b);
EOF
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.10)
project(TestLib)
add_library(mylib mylib.c)
EOF

mkdir build && cd build
cmake .. && cmake --build .
ls -la libmylib.*
cd ../..

echo "=== Test 6: CMake generator expressions ==="

mkdir gen_project && cd gen_project
cp ../simple_project/main.c .
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.10)
project(GenTest)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
add_executable(gen_test main.c)
target_compile_options(gen_test PRIVATE $<$<CONFIG:Debug>:-g> $<$<CONFIG:Release>:-O3>)
EOF

mkdir build && cd build
cmake ..
cmake --build .
cd ../..

echo "=== Test 7: Module finder ==="

mkdir finder_project && cd finder_project
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.10)
project(FinderTest)
find_package(Threads)
if(Threads_FOUND)
  message(STATUS "Threads found")
else()
  message(STATUS "Threads not found")
endif()
EOF

mkdir build && cd build
cmake ..
cd ../..

echo "=== Test 8: Error handling ==="

# Missing CMakeLists.txt
mkdir bad_project && cd bad_project
cmake . 2>&1 && echo "Unexpected success" || echo "Expected error: no CMakeLists.txt"
cd ..

# Syntax error in CMakeLists.txt
mkdir syntax_project && cd syntax_project
echo "cmake_minimum_required(VERSION 3.10)" > CMakeLists.txt
echo "this_is_invalid()" >> CMakeLists.txt
cmake . 2>&1 && echo "Unexpected success" || echo "Expected error: syntax error"
cd ..

echo "=== Test 9: CMake version check ==="

cmake --version | grep "cmake version"

echo "=== Test 10: CMake help system ==="

cmake --help | head -20
cmake --help-command add_executable | head -10
cmake --help-module FindThreads | head -10

cd /
rm -rf $TmpDir

echo ""
echo "All cmake functional tests passed!"