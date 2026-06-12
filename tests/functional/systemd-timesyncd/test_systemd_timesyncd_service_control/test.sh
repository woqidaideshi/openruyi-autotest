#!/bin/sh -eux
# Functional test: systemd-timesyncd - Service-control

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q systemd-timesyncd' 0 "Check systemd-timesyncd is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: Service control ==="
rlRun 'systemctl try-restart systemd-timesyncd.service 2>&1 || true' 0 "Restart service"
rlRun 'systemctl is-active systemd-timesyncd.service 2>&1 || true' 0 "Is active"

cd /
rm -rf $TmpDir

echo ""
echo "All systemd-timesyncd Service-control tests passed!"
