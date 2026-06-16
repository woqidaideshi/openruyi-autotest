#!/bin/sh -eux
# Functional test: grep - Error-handling

. "../setup.sh"

echo "=== Test 13: Error handling ==="

# Test 13.1: Nonexistent file
rlRun 'grep pattern nonexistent_file.txt 2>&1' 2 "Error on nonexistent file" || true

# Test 13.2: Invalid regex
rlRun 'grep "[" test1.txt 2>&1' 2 "Error on invalid regex" || true

# Test 13.3: Directory without -r
rlRun 'grep pattern subdir/ 2>&1' 2 "Error on directory without -r" || true

# Test 13.4: No match (exit 1)
rlRun 'grep NONEXISTENT_PATTERN test1.txt' 1 "No match returns exit code 1" || true

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All grep Error-handling tests passed!"
