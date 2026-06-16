#!/bin/sh -eux
# Functional test: labwc - Library-check

. "../setup.sh"

echo "=== Test 5: Library check ==="
rlRun 'ldd $(which labwc) 2>&1 | head -10' 0 "labwc: linked libraries"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All labwc Library-check tests passed!"
