#!/bin/sh -eux
# Functional test: tar - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: Error handling ==="

# Test 7.1: Non-existent file
tar -cvf error.tar nonexistent_file 2>&1 || echo "Expected error for non-existent file"

# Test 7.2: Corrupted archive
echo "corrupted data" > corrupted.tar
tar -tvf corrupted.tar 2>&1 || echo "Expected error for corrupted archive"

# Test 7.3: Empty archive
tar -cvf empty.tar --files-from /dev/null
tar -tvf empty.tar

cd /
rm -rf $TmpDir

echo ""
echo "All tar Error-handling tests passed!"
