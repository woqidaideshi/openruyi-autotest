#!/bin/sh -eux
# Functional test: systemd - systemd-sysext

. "../setup.sh"

echo "=== Test 34: systemd-sysext ==="

rlRun 'systemd-sysext --help 2>&1 | head -5' 0 "systemd-sysext help"

# ===================================================================

. "../teardown.sh"
echo "All systemd systemd-sysext tests passed!"
