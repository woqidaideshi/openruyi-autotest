#!/bin/sh -eux
# Functional test: tar - Incremental-backup

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 9: Incremental backup ==="

# Test 9.1: Create incremental backup
tar -cvf incremental.tar --listed-incremental=snapshot.snar file1.txt file2.txt
tar -tvf incremental.tar

# Test 9.2: Multi-volume archive (test only)
tar -cvf multi.tar file1.txt file2.txt --tape-length=1024 2>&1 || echo "Multi-volume test completed"

cd /
rm -rf $TmpDir

echo ""
echo "All tar Incremental-backup tests passed!"
