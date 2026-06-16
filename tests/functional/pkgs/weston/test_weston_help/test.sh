#!/bin/sh -eux
# Functional test: weston - Help

. "../setup.sh"

echo "=== Test 2: Help ==="
rlRun 'weston --help 2>&1 | head -20' 0 "weston help"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All weston Help tests passed!"
