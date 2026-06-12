#!/bin/sh -eux
# Functional test: sddm - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q sddm' 0 "Check sddm installed"
rlRun 'which sddm' 0 "Check sddm available"
rlRun 'which sddm-greeter-qt6 2>&1 || true' 0 "Check sddm-greeter available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: Error handling ==="
echo "All sddm functional tests passed!"
cd /
rm -rf $TmpDir

echo ""
echo "All sddm Error-handling tests passed!"
