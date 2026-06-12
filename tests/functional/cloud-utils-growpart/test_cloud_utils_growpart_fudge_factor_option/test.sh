#!/bin/sh -eux
# Functional test: cloud-utils-growpart - Fudge-factor-option

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q cloud-utils-growpart' 0 "Check cloud-utils-growpart installed"
rlRun 'which growpart' 0 "Check growpart command available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 5: Fudge factor option ==="
rlRun 'growpart --help 2>&1 | grep -q "fudge"' 0 "growpart: has fudge option"

cd /
rm -rf $TmpDir

echo ""
echo "All cloud-utils-growpart Fudge-factor-option tests passed!"
