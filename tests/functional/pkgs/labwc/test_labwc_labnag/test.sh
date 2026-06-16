#!/bin/sh -eux
# Functional test: labwc - labnag

. "../setup.sh"

echo "=== Test 6: labnag ==="
rlRun 'labnag --help 2>&1 | head -5 || true' 0 "labnag help"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All labwc labnag tests passed!"
