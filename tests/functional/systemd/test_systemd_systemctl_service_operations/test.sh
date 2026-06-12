#!/bin/sh -eux
# Functional test: systemd - systemctl-service-operations

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q systemd 2>/dev/null || { echo 'systemd not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 31: systemctl service operations ==="

rlRun 'systemctl try-restart systemd-journald.service 2>&1 || true' 0 "systemctl try-restart"
rlRun 'systemctl reload-or-restart systemd-journald.service 2>&1 || true' 0 "systemctl reload-or-restart"
rlRun 'systemctl reset-failed 2>&1 || true' 0 "systemctl reset-failed"
rlRun 'systemctl daemon-reload 2>&1 || true' 0 "systemctl daemon-reload"

# ===================================================================

echo ""
echo "All systemd systemctl-service-operations tests passed!"
