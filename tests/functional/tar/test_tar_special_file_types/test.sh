#!/bin/sh -eux
# Functional test: tar - Special-file-types

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 10: Special file types ==="

# Test 10.1: Archive with symlinks
ln -s file1.txt link_to_file1
tar -cvhf symlink_archive.tar link_to_file1
tar -tvf symlink_archive.tar

# Test 10.2: Archive with hardlinks
ln file1.txt hardlink_to_file1
tar -cvf hardlink_archive.tar hardlink_to_file1
tar -tvf hardlink_archive.tar

# Cleanup
cd /
rm -rf $TmpDir

echo ""
echo "All tar functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All tar Special-file-types tests passed!"
