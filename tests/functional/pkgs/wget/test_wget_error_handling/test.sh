#!/bin/sh -eux
# Functional test: wget - Error-handling

. "../setup.sh"

echo "=== Test 12: Error handling ==="

# Invalid URL
wget -q http://nonexistent.domain.invalid 2>&1 || echo "Expected: invalid host"

# 404 error
wget -q https://example.com/nonexistent 2>&1 || echo "Expected: 404 error"

# Invalid option
wget --invalid-option 2>&1 || echo "Expected: invalid option"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget Error-handling tests passed!"
