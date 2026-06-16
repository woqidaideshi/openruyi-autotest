#!/bin/sh -eux
# Functional test: weston - Weston-debug

. "../setup.sh"

echo "=== Test 4: Weston debug ==="
rlRun 'weston-debug --help 2>&1 | head -5' 0 "weston-debug help"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All weston Weston-debug tests passed!"
