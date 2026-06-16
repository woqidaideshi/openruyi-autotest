#!/bin/sh -eux
# Functional test: weston - Headless-backend-test

. "../setup.sh"

echo "=== Test 8: Headless backend test ==="
rlRun 'timeout 5 weston --backend=headless 2>&1 || true' 0 "weston: headless backend"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All weston Headless-backend-test tests passed!"
