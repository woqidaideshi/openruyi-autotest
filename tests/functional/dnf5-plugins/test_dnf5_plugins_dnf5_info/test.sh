#!/bin/sh -eux
# Functional test: dnf5-plugins - dnf5-info

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q dnf5-plugins' 0 "Check dnf5-plugins installed"
rlRun 'which dnf5' 0 "Check dnf5 available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 9: dnf5 info ==="
rlRun 'dnf5 info dnf5 2>&1 | head -10' 0 "dnf5 info"

cd /
rm -rf $TmpDir

echo ""
echo "All dnf5-plugins dnf5-info tests passed!"
