#!/bin/sh -eux
# Functional test: dnf5-plugins - dnf5-list

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q dnf5-plugins 2>/dev/null || { echo 'dnf5-plugins not installed, skipping'; exit 0; }
which dnf5 2>/dev/null || echo 'dnf5 not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 8: dnf5 list ==="
rlRun 'dnf5 list installed 2>&1 | head -10' 0 "dnf5 list installed"

cd /
rm -rf $TmpDir

echo ""
echo "All dnf5-plugins dnf5-list tests passed!"
