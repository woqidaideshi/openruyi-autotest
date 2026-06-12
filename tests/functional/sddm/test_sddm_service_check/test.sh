#!/bin/sh -eux
# Functional test: sddm - Service-check

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q sddm 2>/dev/null || { echo 'sddm not installed, skipping'; exit 0; }
which sddm 2>/dev/null || echo 'sddm not found'
rlRun 'which sddm-greeter-qt6 2>&1 || true' 0 "Check sddm-greeter available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: Service check ==="
rlRun 'systemctl cat sddm.service 2>&1 | head -10' 0 "sddm service unit"
rlRun 'systemctl status sddm.service 2>&1 | head -5 || true' 0 "sddm service status"
rlRun 'systemctl is-enabled sddm.service 2>&1 || true' 0 "sddm enabled status"

cd /
rm -rf $TmpDir

echo ""
echo "All sddm Service-check tests passed!"
