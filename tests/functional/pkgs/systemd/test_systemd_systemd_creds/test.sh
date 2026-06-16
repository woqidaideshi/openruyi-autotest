#!/bin/sh -eux
# Functional test: systemd - systemd-creds

. "../setup.sh"

echo "=== Test 25: systemd-creds ==="

rlRun 'systemd-creds --help 2>&1 | head -5' 0 "systemd-creds help"

# ===================================================================

. "../teardown.sh"
echo "All systemd systemd-creds tests passed!"
