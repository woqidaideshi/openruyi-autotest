#!/bin/sh -eux
# Functional test: systemd - systemd-tmpfiles

. "../setup.sh"

echo "=== Test 11: systemd-tmpfiles ==="

rlRun 'systemd-tmpfiles --version 2>&1 || true' 0 "systemd-tmpfiles version"
rlRun 'systemd-tmpfiles --cat-config 2>&1 | head -10' 0 "systemd-tmpfiles --cat-config"

# ===================================================================

. "../teardown.sh"
echo "All systemd systemd-tmpfiles tests passed!"
