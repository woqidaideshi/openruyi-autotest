#!/bin/sh -eux
# Functional test: weston - wcap-decode

. "../setup.sh"

echo "=== Test 6: wcap-decode ==="
rlRun 'wcap-decode --help 2>&1 | head -5' 0 "wcap-decode help"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All weston wcap-decode tests passed!"
