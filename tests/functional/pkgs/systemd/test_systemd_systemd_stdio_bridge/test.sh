#!/bin/sh -eux
# Functional test: systemd - systemd-stdio-bridge

. "../setup.sh"

echo "=== Test 29: systemd-stdio-bridge ==="

rlRun 'systemd-stdio-bridge --help 2>&1 | head -3' 0 "systemd-stdio-bridge help"

# ===================================================================

. "../teardown.sh"
echo "All systemd systemd-stdio-bridge tests passed!"
