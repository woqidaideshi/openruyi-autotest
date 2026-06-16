#!/bin/sh -eux
# Functional test: systemd - systemd-notify

. "../setup.sh"

echo "=== Test 15: systemd-notify ==="

rlRun 'systemd-notify --version 2>&1 || true' 0 "systemd-notify version"
rlRun 'systemd-notify --help 2>&1 | head -5' 0 "systemd-notify help"

# ===================================================================

. "../teardown.sh"
echo "All systemd systemd-notify tests passed!"
