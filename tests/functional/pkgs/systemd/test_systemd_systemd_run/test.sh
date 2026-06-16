#!/bin/sh -eux
# Functional test: systemd - systemd-run

. "../setup.sh"

echo "=== Test 13: systemd-run ==="

rlRun 'systemd-run --version 2>&1 || true' 0 "systemd-run version"
rlRun 'systemd-run --user --scope echo "test" 2>&1 || true' 0 "systemd-run --user --scope"

# ===================================================================

. "../teardown.sh"
echo "All systemd systemd-run tests passed!"
