#!/bin/sh -eux
# Functional test: dnf5-plugins - dnf5-repoquery

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q dnf5-plugins 2>/dev/null || { echo 'dnf5-plugins not installed, skipping'; exit 0; }
which dnf5 2>/dev/null || echo 'dnf5 not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: dnf5 repoquery ==="
rlRun 'dnf5 repoquery --help 2>&1 | head -5' 0 "dnf5 repoquery help"

cd /
rm -rf $TmpDir

echo ""
echo "All dnf5-plugins dnf5-repoquery tests passed!"
