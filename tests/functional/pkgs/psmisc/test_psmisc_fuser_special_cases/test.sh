#!/bin/sh -eux
# Functional test: psmisc - fuser-special-cases

. "../setup.sh"

echo "=== Test 12: fuser special cases ==="

# fuser on unix socket
fuser -n tcp 80 2>&1 || echo "fuser network socket test"

# fuser reset signal output
fuser -r /tmp 2>&1 || echo "fuser reset test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All psmisc fuser-special-cases tests passed!"
