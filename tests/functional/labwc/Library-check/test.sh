#!/bin/sh -eux
# Functional test: labwc - Library-check

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q labwc' 0 "Check labwc installed"
rlRun 'which labwc' 0 "Check labwc available"
rlRun 'which labnag' 0 "Check labnag available"
rlRun 'which lab-sensible-terminal' 0 "Check lab-sensible-terminal available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 5: Library check ==="
rlRun 'ldd $(which labwc) 2>&1 | head -10' 0 "labwc: linked libraries"

cd /
rm -rf $TmpDir

echo ""
echo "All labwc Library-check tests passed!"
