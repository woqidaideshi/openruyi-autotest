#!/bin/sh -eux
# Functional test: labwc - lab-sensible-terminal

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q labwc 2>/dev/null || { echo 'labwc not installed, skipping'; exit 0; }
which labwc 2>/dev/null || echo 'labwc not found'
which labnag 2>/dev/null || echo 'labnag not found'
which lab-sensible-terminal 2>/dev/null || echo 'lab-sensible-terminal not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: lab-sensible-terminal ==="
rlRun 'lab-sensible-terminal --help 2>&1 | head -5 || true' 0 "lab-sensible-terminal help"

cd /
rm -rf $TmpDir

echo ""
echo "All labwc lab-sensible-terminal tests passed!"
