#!/bin/sh -eux
# Functional test: tar - Archive-extraction

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 2: Archive extraction ==="

# Test 2.1: Extract archive
mkdir extract_dir
cd extract_dir
tar -xvf ../archive.tar
ls -la
cd ..

# Test 2.2: Verify extracted files
cat extract_dir/file1.txt
cat extract_dir/file2.txt

cd /
rm -rf $TmpDir

echo ""
echo "All tar Archive-extraction tests passed!"
