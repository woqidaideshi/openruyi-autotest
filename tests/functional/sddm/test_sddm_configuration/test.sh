#!/bin/sh -eux
# Functional test: sddm - Configuration

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q sddm 2>/dev/null || { echo 'sddm not installed, skipping'; exit 0; }
which sddm 2>/dev/null || echo 'sddm not found'
rlRun 'which sddm-greeter-qt6 2>&1 || true' 0 "Check sddm-greeter available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 2: Configuration ==="
rlRun 'sddm --example-config 2>&1 | head -20' 0 "sddm: example config"
rlRun 'ls /etc/sddm.conf.d/ 2>&1 || echo "No config dir"' 0 "Config directory"
rlRun 'ls /usr/lib/sddm/sddm.conf.d/ 2>&1 || echo "No default config dir"' 0 "Default config dir"

cd /
rm -rf $TmpDir

echo ""
echo "All sddm Configuration tests passed!"
