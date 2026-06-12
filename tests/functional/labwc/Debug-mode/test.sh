#!/bin/sh -eux
# Functional test: labwc - Debug-mode

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q labwc' 0 "Check labwc installed"
rlRun 'which labwc' 0 "Check labwc available"
rlRun 'which labnag' 0 "Check labnag available"
rlRun 'which lab-sensible-terminal' 0 "Check lab-sensible-terminal available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: Debug mode ==="
rlRun 'labwc --help 2>&1 | grep -E "\-\-debug|\-d"' 0 "labwc: debug option"

cd /
rm -rf $TmpDir

echo ""
echo "All labwc Debug-mode tests passed!"
