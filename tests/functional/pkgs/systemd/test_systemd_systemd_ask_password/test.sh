#!/bin/sh -eux
# Functional test: systemd - systemd-ask-password

. "../setup.sh"

echo "=== Test 24: systemd-ask-password ==="

rlRun 'systemd-ask-password --help 2>&1 | head -3' 0 "systemd-ask-password help"

# ===================================================================

. "../teardown.sh"
echo "All systemd systemd-ask-password tests passed!"
