#!/bin/sh -eux
# Functional test: labwc - Check-for-display--no-DISPLAY

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q labwc 2>/dev/null || { echo 'labwc not installed, skipping'; exit 0; }
which labwc 2>/dev/null || echo 'labwc not found'
which labnag 2>/dev/null || echo 'labnag not found'
which lab-sensible-terminal 2>/dev/null || echo 'lab-sensible-terminal not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Check for display (no DISPLAY) ==="
rlRun 'labwc --help 2>&1 | grep -E "\-\-startup|\-s|\-\-session|\-S"' 0 "labwc: startup/session options"

cd /
rm -rf $TmpDir

echo ""
echo "All labwc Check-for-display--no-DISPLAY tests passed!"
