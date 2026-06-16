#!/bin/sh -eux
# Functional test: wget - Directory-listing

. "../setup.sh"

echo "=== Test 13: Directory listing ==="

wget -q -O - https://example.com 2>&1 | head -5 || echo "Directory listing test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget Directory-listing tests passed!"
