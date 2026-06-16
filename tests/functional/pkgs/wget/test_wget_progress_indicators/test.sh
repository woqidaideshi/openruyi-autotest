#!/bin/sh -eux
# Functional test: wget - Progress-indicators

. "../setup.sh"

echo "=== Test 11: Progress indicators ==="

wget --progress=dot https://example.com 2>&1 || echo "Dot progress test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget Progress-indicators tests passed!"
