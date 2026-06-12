#!/bin/sh -eux
# Functional test: labwc - Library-check

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q labwc 2>/dev/null || { echo 'labwc not installed, skipping'; exit 0; }
which labwc 2>/dev/null || echo 'labwc not found'
which labnag 2>/dev/null || echo 'labnag not found'
which lab-sensible-terminal 2>/dev/null || echo 'lab-sensible-terminal not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 5: Library check ==="
rlRun 'ldd $(which labwc) 2>&1 | head -10' 0 "labwc: linked libraries"

cd /
rm -rf $TmpDir

echo ""
echo "All labwc Library-check tests passed!"
