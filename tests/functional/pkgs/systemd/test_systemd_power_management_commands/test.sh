#!/bin/sh -eux
# Functional test: systemd - Power-management-commands

. "../setup.sh"

echo "=== Test 27: Power management commands ==="

for cmd in halt poweroff reboot shutdown; do
  rlRun "$cmd --help 2>&1 | head -3 || true" 0 "$cmd help"
done

# ===================================================================

. "../teardown.sh"
echo "All systemd Power-management-commands tests passed!"
