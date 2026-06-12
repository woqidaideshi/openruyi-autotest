#!/bin/sh -eux
# Functional test: labwc - Configuration

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q labwc' 0 "Check labwc installed"
rlRun 'which labwc' 0 "Check labwc available"
rlRun 'which labnag' 0 "Check labnag available"
rlRun 'which lab-sensible-terminal' 0 "Check lab-sensible-terminal available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 2: Configuration ==="
rlRun 'labwc --help 2>&1 | grep -E "\-\-config|\-\-merge-config|\-\-reconfigure"' 0 "labwc: config options"

cd /
rm -rf $TmpDir

echo ""
echo "All labwc Configuration tests passed!"
