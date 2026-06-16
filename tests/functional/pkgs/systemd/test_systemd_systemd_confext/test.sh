#!/bin/sh -eux
# Functional test: systemd - systemd-confext

. "../setup.sh"

echo "=== Test 35: systemd-confext ==="

rlRun 'systemd-confext --help 2>&1 | head -5' 0 "systemd-confext help"

# ===================================================================

. "../teardown.sh"
echo "All systemd systemd-confext tests passed!"
