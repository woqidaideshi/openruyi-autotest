#!/bin/sh -eux
# Functional test: gcc - GCC-toolchain-utilities

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q gcc 2>/dev/null || { echo 'gcc not installed, skipping'; exit 0; }
rpm -q gcc-c++ 2>/dev/null || { echo 'gcc-c++ not installed, skipping'; exit 0; }
which gcc 2>/dev/null || echo 'gcc not found'
which g++ 2>/dev/null || echo 'g++ not found'
which cpp 2>/dev/null || echo 'cpp not found'
rlRun 'gcc --version' 0 "Get gcc version info"
rlRun 'g++ --version' 0 "Get g++ version info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 12: GCC toolchain utilities ==="

# Test 12.1: gcc-ar (archive tool)
rlRun 'gcc-ar --version' 0 "gcc-ar version check"

# Test 12.2: gcc-nm (symbol listing)
rlRun 'gcc-nm --version' 0 "gcc-nm version check"

# Test 12.3: gcc-ranlib (archive index)
rlRun 'gcc-ranlib --version' 0 "gcc-ranlib version check"

# Test 12.4: gcov-dump
rlRun 'gcov-dump --version' 0 "gcov-dump version check"

# Test 12.5: gcov-tool
rlRun 'gcov-tool --version' 0 "gcov-tool version check"

# Test 12.6: lto-dump
rlRun 'lto-dump --version' 0 "lto-dump version check"

# Test 12.7: cc (C compiler symlink)
rlRun 'cc --version' 0 "cc version check"
rlRun 'test "$(cc --version 2>&1 | head -1)" = "$(gcc --version 2>&1 | head -1)"' 0 "cc equals gcc"

# Test 12.8: c++ (C++ compiler symlink)
rlRun 'c++ --version' 0 "c++ version check"
rlRun 'test "$(c++ --version 2>&1 | head -1)" = "$(g++ --version 2>&1 | head -1)"' 0 "c++ equals g++"

cd /
rm -rf $TmpDir

echo ""
echo "All gcc functional tests passed!"

echo ""
echo "All gcc GCC-toolchain-utilities tests passed!"
