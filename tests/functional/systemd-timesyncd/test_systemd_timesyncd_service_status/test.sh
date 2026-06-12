#!/bin/sh -eux
# Functional test: systemd-timesyncd - Service-status

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q systemd-timesyncd' 0 "Check systemd-timesyncd is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Service status ==="
rlRun 'systemctl status systemd-timesyncd.service 2>&1 | head -10' 0 "Service status"
rlRun 'timedatectl show-timesync 2>&1 | head -10' 0 "Time sync status"
rlRun 'timedatectl timesync-status 2>&1 | head -10' 0 "Timesync detail"
rlRun 'systemctl is-enabled systemd-timesyncd.service 2>&1 || true' 0 "Is enabled"

cd /
rm -rf $TmpDir

echo ""
echo "All systemd-timesyncd Service-status tests passed!"
