#!/bin/sh -eux
# Functional test: weston - Backend-check

. "../setup.sh"

echo "=== Test 7: Backend check ==="
rlRun 'weston --help 2>&1 | grep -i "backend" | head -5' 0 "Available backends"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All weston Backend-check tests passed!"
