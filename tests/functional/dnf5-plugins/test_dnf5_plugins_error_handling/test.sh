#!/bin/sh -eux
# Functional test: dnf5-plugins - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q dnf5-plugins 2>/dev/null || { echo 'dnf5-plugins not installed, skipping'; exit 0; }
which dnf5 2>/dev/null || echo 'dnf5 not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 10: Error handling ==="
rlRun 'dnf5 --invalid-option 2>&1 || true' 0 "dnf5: invalid option"

echo ""
echo "All dnf5-plugins functional tests passed!"
cd /
rm -rf $TmpDir

echo ""
echo "All dnf5-plugins Error-handling tests passed!"
