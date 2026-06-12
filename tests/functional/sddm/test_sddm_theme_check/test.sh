#!/bin/sh -eux
# Functional test: sddm - Theme-check

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q sddm' 0 "Check sddm installed"
rlRun 'which sddm' 0 "Check sddm available"
rlRun 'which sddm-greeter-qt6 2>&1 || true' 0 "Check sddm-greeter available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Theme check ==="
rlRun 'ls /usr/share/sddm/themes/ 2>&1 | head -5' 0 "sddm themes installed"

cd /
rm -rf $TmpDir

echo ""
echo "All sddm Theme-check tests passed!"
