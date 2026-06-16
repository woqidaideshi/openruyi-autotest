#!/bin/sh -eux
# Functional test: systemd - systemd-machine-id-setup

. "../setup.sh"

echo "=== Test 18: systemd-machine-id-setup ==="

rlRun 'systemd-machine-id-setup --help 2>&1 | head -3' 0 "systemd-machine-id-setup help"
rlRun 'cat /etc/machine-id' 0 "systemd-machine-id-setup: check machine-id"

# ===================================================================

. "../teardown.sh"
echo "All systemd systemd-machine-id-setup tests passed!"
