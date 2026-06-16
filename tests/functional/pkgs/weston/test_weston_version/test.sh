#!/bin/sh -eux
# Functional test: weston - Version

. "../setup.sh"

echo "=== Test 1: Version ==="
rlRun 'weston --version' 0 "weston version"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All weston Version tests passed!"
