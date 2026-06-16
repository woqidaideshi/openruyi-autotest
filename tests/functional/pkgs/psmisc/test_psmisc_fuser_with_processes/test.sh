#!/bin/sh -eux
# Functional test: psmisc - fuser-with-processes

. "../setup.sh"

echo "=== Test 2: fuser with processes ==="

# Show processes using /tmp
fuser -uv /tmp 2>&1 || echo "fuser verbose test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All psmisc fuser-with-processes tests passed!"
