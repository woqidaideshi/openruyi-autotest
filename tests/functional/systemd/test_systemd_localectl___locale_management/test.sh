#!/bin/sh -eux
# Functional test: systemd - localectl---Locale-management

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q systemd 2>/dev/null || { echo 'systemd not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 5: localectl - Locale management ==="

rlRun 'localectl --version 2>&1 || true' 0 "localectl version"
rlRun 'localectl status' 0 "localectl status: locale info"
rlRun 'localectl list-locales 2>&1 | head -10' 0 "localectl list-locales"

# ===================================================================

echo ""
echo "All systemd localectl---Locale-management tests passed!"
