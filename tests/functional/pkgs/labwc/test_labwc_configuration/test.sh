#!/bin/sh -eux
# Functional test: labwc - Configuration

. "../setup.sh"

echo "=== Test 2: Configuration ==="
rlRun 'labwc --help 2>&1 | grep -E "\-\-config|\-\-merge-config|\-\-reconfigure"' 0 "labwc: config options"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All labwc Configuration tests passed!"
