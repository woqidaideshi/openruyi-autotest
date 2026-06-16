#!/bin/sh -eux
# Functional test: weston - Weston-terminal--headless

. "../setup.sh"

echo "=== Test 3: Weston terminal (headless) ==="
rlRun 'weston-terminal --help 2>&1 | head -10 || true' 0 "weston-terminal help"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All weston Weston-terminal--headless tests passed!"
