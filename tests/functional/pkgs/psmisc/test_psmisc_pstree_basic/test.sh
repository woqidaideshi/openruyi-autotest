#!/bin/sh -eux
# Functional test: psmisc - pstree-basic

. "../setup.sh"

echo "=== Test 5: pstree basic ==="

pstree | head -20

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All psmisc pstree-basic tests passed!"
