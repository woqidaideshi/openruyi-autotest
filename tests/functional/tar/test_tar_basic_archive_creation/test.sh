#!/bin/sh -eux
# Functional test: tar - Basic-archive-creation

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Basic archive creation ==="

# Test 1.1: Create test files
echo "file1 content" > file1.txt
echo "file2 content" > file2.txt
mkdir testdir
echo "file3 content" > testdir/file3.txt

# Test 1.2: Create tar archive
tar -cvf archive.tar file1.txt file2.txt

# Test 1.3: List archive contents
tar -tvf archive.tar

cd /
rm -rf $TmpDir

echo ""
echo "All tar Basic-archive-creation tests passed!"
