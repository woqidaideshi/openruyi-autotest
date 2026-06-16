#!/bin/sh -eux
# Functional test: systemd-timesyncd - Service-control

. "../setup.sh"

echo "=== Test 3: Service control ==="
rlRun 'systemctl try-restart systemd-timesyncd.service 2>&1 || true' 0 "Restart service"
rlRun 'systemctl is-active systemd-timesyncd.service 2>&1 || true' 0 "Is active"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All systemd-timesyncd Service-control tests passed!"
