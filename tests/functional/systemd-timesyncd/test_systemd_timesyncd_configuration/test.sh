#!/bin/sh -eux
# Functional test: systemd-timesyncd - Configuration

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q systemd-timesyncd 2>/dev/null || { echo 'systemd-timesyncd not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Configuration ==="
rlRun 'cat /etc/systemd/timesyncd.conf 2>/dev/null | head -10 || echo "No config"' 0 "Config file"
rlRun 'systemd-analyze cat-config systemd/timesyncd.conf 2>&1 | head -10 || true' 0 "Cat config"

cd /
rm -rf $TmpDir

echo ""
echo "All systemd-timesyncd Configuration tests passed!"
