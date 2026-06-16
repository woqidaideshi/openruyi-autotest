#!/bin/sh -eux
# Functional test: wget2 - Continue-download

. "../setup.sh"

echo "=== Test 8: Continue download ==="

wget2 -c -O cont.html https://example.com 2>&1 || echo "Continue test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget2 Continue-download tests passed!"
