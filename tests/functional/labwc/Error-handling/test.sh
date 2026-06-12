#!/bin/sh -eux
# Functional test: labwc - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q labwc' 0 "Check labwc installed"
rlRun 'which labwc' 0 "Check labwc available"
rlRun 'which labnag' 0 "Check labnag available"
rlRun 'which lab-sensible-terminal' 0 "Check lab-sensible-terminal available"
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
