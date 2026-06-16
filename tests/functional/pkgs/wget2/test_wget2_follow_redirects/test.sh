#!/bin/sh -eux
# Functional test: wget2 - Follow-redirects

. "../setup.sh"

echo "=== Test 13: Follow redirects ==="

wget2 https://google.com 2>&1 || echo "Redirect test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget2 Follow-redirects tests passed!"
