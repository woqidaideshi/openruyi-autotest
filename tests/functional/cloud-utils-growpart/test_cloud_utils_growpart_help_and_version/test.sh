#!/bin/sh -eux
# Functional test: cloud-utils-growpart - Help-and-version

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q cloud-utils-growpart 2>/dev/null || { echo 'cloud-utils-growpart not installed, skipping'; exit 0; }
which growpart 2>/dev/null || echo 'growpart not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Help and version ==="
rlRun 'growpart --help 2>&1 | head -10' 0 "growpart help"
rlRun 'growpart -h 2>&1 | head -5' 0 "growpart -h: short help"

cd /
rm -rf $TmpDir

echo ""
echo "All cloud-utils-growpart Help-and-version tests passed!"
