#!/bin/sh -eux
# Functional test: dnf5-plugins - dnf5-info

. "../setup.sh"

echo "=== Test 9: dnf5 info ==="
rlRun 'dnf5 info dnf5 2>&1 | head -10' 0 "dnf5 info"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All dnf5-plugins dnf5-info tests passed!"
