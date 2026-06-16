#!/bin/sh -eux
# Functional test: dnf5-plugins - dnf5-version

. "../setup.sh"

echo "=== Test 1: dnf5 version ==="
rlRun 'dnf5 --version' 0 "dnf5 version"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All dnf5-plugins dnf5-version tests passed!"
