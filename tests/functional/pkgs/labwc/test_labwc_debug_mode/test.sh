#!/bin/sh -eux
# Functional test: labwc - Debug-mode

. "../setup.sh"

echo "=== Test 3: Debug mode ==="
rlRun 'labwc --help 2>&1 | grep -E "\-\-debug|\-d"' 0 "labwc: debug option"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All labwc Debug-mode tests passed!"
