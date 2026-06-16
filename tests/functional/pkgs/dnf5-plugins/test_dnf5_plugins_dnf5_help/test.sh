#!/bin/sh -eux
# Functional test: dnf5-plugins - dnf5-help

. "../setup.sh"

echo "=== Test 2: dnf5 help ==="
rlRun 'dnf5 --help 2>&1 | head -20' 0 "dnf5 help"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All dnf5-plugins dnf5-help tests passed!"
