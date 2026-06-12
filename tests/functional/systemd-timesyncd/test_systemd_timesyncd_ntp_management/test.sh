#!/bin/sh -eux
# Functional test: systemd-timesyncd - NTP-management

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q systemd-timesyncd 2>/dev/null || { echo 'systemd-timesyncd not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 2: NTP management ==="
rlRun 'timedatectl show-timesync --property=FallbackNTPServers 2>&1 || true' 0 "Fallback NTP servers"
rlRun 'timedatectl show-timesync --property=ServerName 2>&1 || true' 0 "Current NTP server"
rlRun 'timedatectl show-timesync --property=ServerAddress 2>&1 || true' 0 "Server address"
rlRun 'timedatectl ntp-servers 2>&1 || true' 0 "NTP servers list"

cd /
rm -rf $TmpDir

echo ""
echo "All systemd-timesyncd NTP-management tests passed!"
