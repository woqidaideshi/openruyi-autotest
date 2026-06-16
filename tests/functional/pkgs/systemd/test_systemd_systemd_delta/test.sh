#!/bin/sh -eux
# Functional test: systemd - systemd-delta

. "../setup.sh"

echo "=== Test 20: systemd-delta ==="

rlRun 'systemd-delta --help 2>&1 | head -3' 0 "systemd-delta help"
rlRun 'systemd-delta 2>&1 | head -10' 0 "systemd-delta: show overrides"

# ===================================================================

. "../teardown.sh"
echo "All systemd systemd-delta tests passed!"
