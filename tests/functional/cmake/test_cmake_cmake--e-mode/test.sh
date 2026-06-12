#!/bin/sh -eux
# Functional test: cmake - CMake--E-mode

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: CMake -E mode ==="
cmake -E echo "test"
cmake -E environment 2>&1 | head -5
cmake -E make_directory test_dir && test -d test_dir

cd /
rm -rf $TmpDir

echo ""
echo "All cmake CMake--E-mode tests passed!"
