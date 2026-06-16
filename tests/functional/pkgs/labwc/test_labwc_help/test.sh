#!/bin/sh -eux
# Functional test: labwc - Help

. "../setup.sh"

echo "=== Test 1: Help ==="
rlRun 'labwc --help 2>&1' 0 "labwc help"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All labwc Help tests passed!"
