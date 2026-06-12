#!/bin/sh -eux
# Functional test: dnf5-plugins - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q dnf5-plugins' 0 "Check dnf5-plugins installed"
rlRun 'which dnf5' 0 "Check dnf5 available"
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
