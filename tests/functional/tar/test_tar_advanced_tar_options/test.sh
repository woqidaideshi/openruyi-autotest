#!/bin/sh -eux
# Functional test: tar - Advanced-tar-options

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Advanced tar options ==="

# Test 4.1: Append files to existing archive
tar -rvf archive.tar testdir
tar -tvf archive.tar

# Test 4.2: Extract specific files
mkdir extract_specific && cd extract_specific
tar -xvf ../archive.tar file1.txt
ls -la
cd ..

# Test 4.3: Extract to different directory
mkdir -p target_dir
tar -xvf archive.tar -C target_dir
ls -la target_dir

# Test 4.4: Create archive from directory
tar -cvf dir_archive.tar testdir
tar -tvf dir_archive.tar

cd /
rm -rf $TmpDir

echo ""
echo "All tar Advanced-tar-options tests passed!"
