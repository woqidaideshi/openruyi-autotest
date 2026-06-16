#!/bin/sh -eux
# Functional test: tar - Archive-extraction

. "../setup.sh"

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

. "../teardown.sh"
echo "All tar Archive-extraction tests passed!"
