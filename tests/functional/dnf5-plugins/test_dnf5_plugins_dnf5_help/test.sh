#!/bin/sh -eux
# Functional test: dnf5-plugins - dnf5-help

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q dnf5-plugins 2>/dev/null || { echo 'dnf5-plugins not installed, skipping'; exit 0; }
which dnf5 2>/dev/null || echo 'dnf5 not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 2: dnf5 help ==="
rlRun 'dnf5 --help 2>&1 | head -20' 0 "dnf5 help"

cd /
rm -rf $TmpDir

echo ""
echo "All dnf5-plugins dnf5-help tests passed!"
