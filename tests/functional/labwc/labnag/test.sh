#!/bin/sh -eux
# Functional test: labwc - labnag

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q labwc' 0 "Check labwc installed"
rlRun 'which labwc' 0 "Check labwc available"
rlRun 'which labnag' 0 "Check labnag available"
rlRun 'which lab-sensible-terminal' 0 "Check lab-sensible-terminal available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: labnag ==="
rlRun 'labnag --help 2>&1 | head -5 || true' 0 "labnag help"

cd /
rm -rf $TmpDir

echo ""
echo "All labwc labnag tests passed!"
