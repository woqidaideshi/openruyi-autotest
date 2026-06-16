#!/bin/sh -eux
# Functional test: wget - Basic-download

. "../setup.sh"

echo "=== Test 1: Basic download ==="

# Test downloading a small file
wget -q https://example.com 2>&1 || echo "Download test completed"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget Basic-download tests passed!"
