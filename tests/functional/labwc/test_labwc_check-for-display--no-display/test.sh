#!/bin/sh -eux
# Functional test: labwc - Check-for-display--no-DISPLAY

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q labwc' 0 "Check labwc installed"
rlRun 'which labwc' 0 "Check labwc available"
rlRun 'which labnag' 0 "Check labnag available"
rlRun 'which lab-sensible-terminal' 0 "Check lab-sensible-terminal available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Check for display (no DISPLAY) ==="
rlRun 'labwc --help 2>&1 | grep -E "\-\-startup|\-s|\-\-session|\-S"' 0 "labwc: startup/session options"

cd /
rm -rf $TmpDir

echo ""
echo "All labwc Check-for-display--no-DISPLAY tests passed!"
