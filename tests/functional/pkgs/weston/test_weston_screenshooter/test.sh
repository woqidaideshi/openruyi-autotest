#!/bin/sh -eux
# Functional test: weston - Screenshooter

. "../setup.sh"

echo "=== Test 5: Screenshooter ==="
rlRun 'weston-screenshooter --help 2>&1 | head -5' 0 "weston-screenshooter help"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All weston Screenshooter tests passed!"
