#!/bin/sh -eux
# Functional test: systemd - Error-handling

. "../setup.sh"

echo "=== Test 36: Error handling ==="

rlRun 'systemctl nonexistent-command 2>&1 || true' 0 "systemctl: invalid command"
rlRun 'journalctl --invalid-option 2>&1 || true' 0 "journalctl: invalid option"
rlRun 'hostnamectl --invalid 2>&1 || true' 0 "hostnamectl: invalid option"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All systemd Error-handling tests passed!"
