#!/bin/sh -eux
# Functional test: labwc - Check-for-display--no-DISPLAY

. "../setup.sh"

echo "=== Test 4: Check for display (no DISPLAY) ==="
rlRun 'labwc --help 2>&1 | grep -E "\-\-startup|\-s|\-\-session|\-S"' 0 "labwc: startup/session options"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All labwc Check-for-display--no-DISPLAY tests passed!"
