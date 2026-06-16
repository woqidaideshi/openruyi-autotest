#!/bin/sh -eux
# Functional test: dnf5-plugins - dnf5-repoquery

. "../setup.sh"

echo "=== Test 6: dnf5 repoquery ==="
rlRun 'dnf5 repoquery --help 2>&1 | head -5' 0 "dnf5 repoquery help"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All dnf5-plugins dnf5-repoquery tests passed!"
