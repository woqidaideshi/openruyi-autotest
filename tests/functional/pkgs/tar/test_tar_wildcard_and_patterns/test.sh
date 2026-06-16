#!/bin/sh -eux
# Functional test: tar - Wildcard-and-patterns

. "../setup.sh"

echo "=== Test 8: Wildcard and patterns ==="

# Test 8.1: Extract with wildcard pattern
mkdir pattern_dir && cd pattern_dir
tar -xvf ../archive.tar --wildcards '*.txt'
ls -la
cd ..

# Test 8.2: Exclude patterns
tar -cvf exclude_archive.tar --exclude='*.txt' file1.txt file2.txt testdir
tar -tvf exclude_archive.tar

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All tar Wildcard-and-patterns tests passed!"
