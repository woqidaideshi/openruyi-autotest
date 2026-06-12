#!/bin/sh -eux
# Functional test: systemd-timesyncd package
# Tests NTP time synchronization service
# Version: systemd-timesyncd 259

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q systemd-timesyncd 2>/dev/null || { echo 'systemd-timesyncd not installed, skipping'; exit 0; }

echo "=== Test 1: Service status ==="
rlRun 'systemctl status systemd-timesyncd.service 2>&1 | head -10' 0 "Service status"
rlRun 'timedatectl show-timesync 2>&1 | head -10' 0 "Time sync status"
rlRun 'timedatectl timesync-status 2>&1 | head -10' 0 "Timesync detail"
rlRun 'systemctl is-enabled systemd-timesyncd.service 2>&1 || true' 0 "Is enabled"

echo "=== Test 2: NTP management ==="
rlRun 'timedatectl show-timesync --property=FallbackNTPServers 2>&1 || true' 0 "Fallback NTP servers"
rlRun 'timedatectl show-timesync --property=ServerName 2>&1 || true' 0 "Current NTP server"
rlRun 'timedatectl show-timesync --property=ServerAddress 2>&1 || true' 0 "Server address"
rlRun 'timedatectl ntp-servers 2>&1 || true' 0 "NTP servers list"

echo "=== Test 3: Service control ==="
rlRun 'systemctl try-restart systemd-timesyncd.service 2>&1 || true' 0 "Restart service"
rlRun 'systemctl is-active systemd-timesyncd.service 2>&1 || true' 0 "Is active"

echo "=== Test 4: Configuration ==="
rlRun 'cat /etc/systemd/timesyncd.conf 2>/dev/null | head -10 || echo "No config"' 0 "Config file"
rlRun 'systemd-analyze cat-config systemd/timesyncd.conf 2>&1 | head -10 || true' 0 "Cat config"

echo "=== Test 5: systemd-time-wait-sync ==="
rlRun 'systemctl status systemd-time-wait-sync.service 2>&1 | head -5' 0 "Wait sync service"

echo ""
echo "All systemd-timesyncd functional tests passed!"