#!/bin/sh -eux
# Functional test: cloud-utils-growpart - Free-percent-option

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q cloud-utils-growpart 2>/dev/null || { echo 'cloud-utils-growpart not installed, skipping'; exit 0; }
which growpart 2>/dev/null || echo 'growpart not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Free percent option ==="
rlRun 'growpart --help 2>&1 | grep -q "free-percent"' 0 "growpart: has free-percent option"

cd /
rm -rf $TmpDir

echo ""
echo "All cloud-utils-growpart Free-percent-option tests passed!"
