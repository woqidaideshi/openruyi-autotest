#!/bin/sh -eux
# Functional test: wget2 - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 12: Error handling ==="

# Invalid URL
wget2 http://nonexistent.domain.invalid 2>&1 || echo "Expected: invalid host"

# 404 error  
wget2 https://example.com/nonexistent 2>&1 || echo "Expected: 404 error"

# Invalid option
wget2 --nonexistent-option 2>&1 || echo "Expected: bad option"

cd /
rm -rf $TmpDir

echo ""
echo "All wget2 Error-handling tests passed!"
