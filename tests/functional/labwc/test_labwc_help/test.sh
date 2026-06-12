#!/bin/sh -eux
# Functional test: labwc - Help

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q labwc 2>/dev/null || { echo 'labwc not installed, skipping'; exit 0; }
which labwc 2>/dev/null || echo 'labwc not found'
which labnag 2>/dev/null || echo 'labnag not found'
which lab-sensible-terminal 2>/dev/null || echo 'lab-sensible-terminal not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Help ==="
rlRun 'labwc --help 2>&1' 0 "labwc help"

cd /
rm -rf $TmpDir

echo ""
echo "All labwc Help tests passed!"
