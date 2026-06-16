#!/bin/sh -eux
# Functional test: dnf5-plugins - dnf5-list

. "../setup.sh"

echo "=== Test 8: dnf5 list ==="
rlRun 'dnf5 list installed 2>&1 | head -10' 0 "dnf5 list installed"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All dnf5-plugins dnf5-list tests passed!"
