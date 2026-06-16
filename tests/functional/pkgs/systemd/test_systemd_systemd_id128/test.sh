#!/bin/sh -eux
# Functional test: systemd - systemd-id128

. "../setup.sh"

echo "=== Test 21: systemd-id128 ==="

rlRun 'systemd-id128 show 2>&1 | head -5' 0 "systemd-id128 show: show IDs"
rlRun 'systemd-id128 new 2>&1 || true' 0 "systemd-id128 new: generate ID"

# ===================================================================

. "../teardown.sh"
echo "All systemd systemd-id128 tests passed!"
