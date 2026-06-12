#!/bin/sh -eux
# Functional test: tar - Archive-verification

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

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

echo ""
echo "All tar Archive-verification tests passed!"
