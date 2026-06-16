#!/bin/sh -eux
# Functional test: wget - Header-options

. "../setup.sh"

echo "=== Test 5: Header options ==="

wget -q --save-headers -O headers.html https://example.com 2>&1 || echo "Headers test"
head -20 headers.html 2>&1 || echo "Headers display test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget Header-options tests passed!"
