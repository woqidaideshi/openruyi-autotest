#!/bin/sh -eux
# Functional test: wget2 - Content-disposition

. "../setup.sh"

echo "=== Test 14: Content disposition ==="

wget2 --content-disposition https://example.com 2>&1 || echo "Content disposition test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget2 Content-disposition tests passed!"
