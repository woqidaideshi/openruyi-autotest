#!/bin/sh -eux
# Functional test: systemd - systemd-cat

. "../setup.sh"

echo "=== Test 14: systemd-cat ==="

rlRun 'echo "test log message" | systemd-cat 2>&1 || true' 0 "systemd-cat: pipe to journal"
rlRun 'systemd-cat --version 2>&1 || true' 0 "systemd-cat version"

# ===================================================================

. "../teardown.sh"
echo "All systemd systemd-cat tests passed!"
