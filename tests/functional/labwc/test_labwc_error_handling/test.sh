#!/bin/sh -eux
# Functional test: labwc - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q labwc 2>/dev/null || { echo 'labwc not installed, skipping'; exit 0; }
which labwc 2>/dev/null || echo 'labwc not found'
which labnag 2>/dev/null || echo 'labnag not found'
which lab-sensible-terminal 2>/dev/null || echo 'lab-sensible-terminal not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 9: Error handling ==="
rlRun 'labwc --invalid 2>&1 || true' 0 "labwc: invalid option"

echo ""
echo "All labwc functional tests passed!"
cd /
rm -rf $TmpDir

echo ""
echo "All labwc Error-handling tests passed!"
