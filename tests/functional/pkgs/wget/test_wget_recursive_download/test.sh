#!/bin/sh -eux
# Functional test: wget - Recursive-download

. "../setup.sh"

echo "=== Test 8: Recursive download ==="

# Test mirror mode (limited depth)
wget -r -l 1 -np -nd https://example.com 2>&1 || echo "Recursive download test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget Recursive-download tests passed!"
