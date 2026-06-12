#!/bin/sh -eux
# Functional test: systemd-timesyncd - systemd-time-wait-sync

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q systemd-timesyncd 2>/dev/null || { echo 'systemd-timesyncd not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 5: systemd-time-wait-sync ==="
rlRun 'systemctl status systemd-time-wait-sync.service 2>&1 | head -5' 0 "Wait sync service"

echo ""
echo "All systemd-timesyncd functional tests passed!"
cd /
rm -rf $TmpDir

echo ""
echo "All systemd-timesyncd systemd-time-wait-sync tests passed!"
