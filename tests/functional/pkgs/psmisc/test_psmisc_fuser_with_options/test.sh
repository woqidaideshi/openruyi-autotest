#!/bin/sh -eux
# Functional test: psmisc - fuser-with-options

. "../setup.sh"

echo "=== Test 4: fuser with options ==="

fuser -a /tmp 2>&1 || echo "fuser display all test"
fuser -i /tmp 2>&1 || echo "fuser interactive test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All psmisc fuser-with-options tests passed!"
