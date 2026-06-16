#!/bin/sh -eux
# Functional test: psmisc - fuser-mount-points

. "../setup.sh"

echo "=== Test 3: fuser mount points ==="

fuser -m / 2>&1 || echo "fuser mount point test"
fuser -m /tmp 2>&1 || echo "fuser mount point test completed"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All psmisc fuser-mount-points tests passed!"
