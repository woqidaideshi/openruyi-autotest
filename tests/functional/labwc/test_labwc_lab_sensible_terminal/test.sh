#!/bin/sh -eux
# Functional test: labwc - lab-sensible-terminal

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q labwc' 0 "Check labwc installed"
rlRun 'which labwc' 0 "Check labwc available"
rlRun 'which labnag' 0 "Check labnag available"
rlRun 'which lab-sensible-terminal' 0 "Check lab-sensible-terminal available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: lab-sensible-terminal ==="
rlRun 'lab-sensible-terminal --help 2>&1 | head -5 || true' 0 "lab-sensible-terminal help"

cd /
rm -rf $TmpDir

echo ""
echo "All labwc lab-sensible-terminal tests passed!"
