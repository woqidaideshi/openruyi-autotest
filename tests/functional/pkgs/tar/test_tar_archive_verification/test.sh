#!/bin/sh -eux
# Functional test: tar - Archive-verification

. "../setup.sh"

echo "=== Test 5: Archive verification ==="

# Test 5.1: Test archive integrity
tar -tvf archive.tar > /dev/null && echo "Archive integrity check passed"

# Test 5.2: Compare archive with original files
mkdir compare_dir && cd compare_dir
tar -xvf ../archive.tar
diff file1.txt ../file1.txt && echo "File comparison passed"
cd ..

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All tar Archive-verification tests passed!"
