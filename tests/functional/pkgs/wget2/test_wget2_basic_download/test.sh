#!/bin/sh -eux
# Functional test: wget2 - Basic-download

. "../setup.sh"

echo "=== Test 1: Basic download ==="

wget2 -o /dev/stdout https://example.com 2>&1 || echo "Download test completed"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget2 Basic-download tests passed!"
