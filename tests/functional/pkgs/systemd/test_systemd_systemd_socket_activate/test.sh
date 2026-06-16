#!/bin/sh -eux
# Functional test: systemd - systemd-socket-activate

. "../setup.sh"

echo "=== Test 26: systemd-socket-activate ==="

rlRun 'systemd-socket-activate --help 2>&1 | head -5' 0 "systemd-socket-activate help"

# ===================================================================

. "../teardown.sh"
echo "All systemd systemd-socket-activate tests passed!"
