#!/bin/sh -eux
# Functional test: labwc - Debug-mode

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q labwc 2>/dev/null || { echo 'labwc not installed, skipping'; exit 0; }
which labwc 2>/dev/null || echo 'labwc not found'
which labnag 2>/dev/null || echo 'labnag not found'
which lab-sensible-terminal 2>/dev/null || echo 'lab-sensible-terminal not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: Debug mode ==="
rlRun 'labwc --help 2>&1 | grep -E "\-\-debug|\-d"' 0 "labwc: debug option"

cd /
rm -rf $TmpDir

echo ""
echo "All labwc Debug-mode tests passed!"
