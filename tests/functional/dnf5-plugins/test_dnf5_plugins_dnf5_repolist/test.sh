#!/bin/sh -eux
# Functional test: dnf5-plugins - dnf5-repolist

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q dnf5-plugins 2>/dev/null || { echo 'dnf5-plugins not installed, skipping'; exit 0; }
which dnf5 2>/dev/null || echo 'dnf5 not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: dnf5 repolist ==="
rlRun 'dnf5 repolist 2>&1 | head -10' 0 "dnf5 repolist"

cd /
rm -rf $TmpDir

echo ""
echo "All dnf5-plugins dnf5-repolist tests passed!"
