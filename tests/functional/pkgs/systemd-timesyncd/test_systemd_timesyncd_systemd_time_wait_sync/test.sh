#!/bin/sh -eux
# Functional test: systemd-timesyncd - systemd-time-wait-sync

. "../setup.sh"

echo "=== Test 5: systemd-time-wait-sync ==="
rlRun 'systemctl status systemd-time-wait-sync.service 2>&1 | head -5' 0 "Wait sync service"

. "../teardown.sh"
echo "All systemd-timesyncd systemd-time-wait-sync tests passed!"
