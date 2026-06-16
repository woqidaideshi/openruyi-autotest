#!/bin/sh -eux
# Functional test: systemd - systemd-path

. "../setup.sh"

echo "=== Test 16: systemd-path ==="

rlRun 'systemd-path' 0 "systemd-path: all paths"
rlRun 'systemd-path systemd-system-config' 0 "systemd-path: specific path"
rlRun 'systemd-path --suffix=test search-bin' 0 "systemd-path --suffix"
rlRun 'systemd-path --help 2>&1 | head -3' 0 "systemd-path help"

# ===================================================================

. "../teardown.sh"
echo "All systemd systemd-path tests passed!"
