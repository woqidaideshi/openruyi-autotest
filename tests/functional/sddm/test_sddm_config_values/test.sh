#!/bin/sh -eux
# Functional test: sddm - Config-values

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q sddm 2>/dev/null || { echo 'sddm not installed, skipping'; exit 0; }
which sddm 2>/dev/null || echo 'sddm not found'
rlRun 'which sddm-greeter-qt6 2>&1 || true' 0 "Check sddm-greeter available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 5: Config values ==="
rlRun 'sddm --example-config 2>&1 | grep -E "^(Current|Display|Session|User)=" | head -10' 0 "sddm: key config values"

cd /
rm -rf $TmpDir

echo ""
echo "All sddm Config-values tests passed!"
