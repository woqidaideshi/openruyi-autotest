#!/bin/sh -eux
# Functional test: systemd - systemd-mount

. "../setup.sh"

echo "=== Test 33: systemd-mount ==="

rlRun 'systemd-mount --help 2>&1 | head -5' 0 "systemd-mount help"

# ===================================================================

. "../teardown.sh"
echo "All systemd systemd-mount tests passed!"
