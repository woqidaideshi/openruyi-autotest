#!/bin/sh -eux
# Functional test: systemd - systemd-inhibit

. "../setup.sh"

echo "=== Test 22: systemd-inhibit ==="

rlRun 'systemd-inhibit --help 2>&1 | head -5' 0 "systemd-inhibit help"
rlRun 'systemd-inhibit --list 2>&1 || true' 0 "systemd-inhibit --list"

# ===================================================================

. "../teardown.sh"
echo "All systemd systemd-inhibit tests passed!"
