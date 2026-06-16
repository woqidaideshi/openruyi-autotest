#!/bin/sh -eux
# Functional test: dnf5-plugins - dnf5-repolist

. "../setup.sh"

echo "=== Test 7: dnf5 repolist ==="
rlRun 'dnf5 repolist 2>&1 | head -10' 0 "dnf5 repolist"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All dnf5-plugins dnf5-repolist tests passed!"
