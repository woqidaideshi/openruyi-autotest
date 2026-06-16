#!/bin/sh -eux
# Functional test: systemd - systemd-firstboot

. "../setup.sh"

echo "=== Test 28: systemd-firstboot ==="

rlRun 'systemd-firstboot --help 2>&1 | head -5' 0 "systemd-firstboot help"

# ===================================================================

. "../teardown.sh"
echo "All systemd systemd-firstboot tests passed!"
