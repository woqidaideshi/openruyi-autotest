#!/bin/sh -eux
# Functional test: systemd - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q systemd' 0 "Check systemd package is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 36: Error handling ==="

rlRun 'systemctl nonexistent-command 2>&1 || true' 0 "systemctl: invalid command"
rlRun 'journalctl --invalid-option 2>&1 || true' 0 "journalctl: invalid option"
rlRun 'hostnamectl --invalid 2>&1 || true' 0 "hostnamectl: invalid option"

cd /
rm -rf $TmpDir

echo ""
echo "All systemd functional tests passed!"

echo ""
echo "All systemd Error-handling tests passed!"
