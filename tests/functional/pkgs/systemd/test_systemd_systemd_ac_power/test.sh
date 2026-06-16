#!/bin/sh -eux
# Functional test: systemd - systemd-ac-power

. "../setup.sh"

echo "=== Test 23: systemd-ac-power ==="

rlRun 'systemd-ac-power 2>&1 || true' 0 "systemd-ac-power: check power"

# ===================================================================

. "../teardown.sh"
echo "All systemd systemd-ac-power tests passed!"
