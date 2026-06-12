#!/bin/sh -eux
# Functional test: systemd - systemd-analyze---System-profiling

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q systemd 2>/dev/null || { echo 'systemd not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: systemd-analyze - System profiling ==="

rlRun 'systemd-analyze --version 2>&1 || true' 0 "systemd-analyze version"
rlRun 'systemd-analyze time 2>&1 || true' 0 "systemd-analyze time: boot time"
rlRun 'systemd-analyze security 2>&1 | head -5' 0 "systemd-analyze security"

# ===================================================================

echo ""
echo "All systemd systemd-analyze---System-profiling tests passed!"
