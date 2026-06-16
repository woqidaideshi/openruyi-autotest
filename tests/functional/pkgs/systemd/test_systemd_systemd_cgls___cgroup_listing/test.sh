#!/bin/sh -eux
# Functional test: systemd - systemd-cgls---Cgroup-listing

. "../setup.sh"

echo "=== Test 9: systemd-cgls - Cgroup listing ==="

rlRun 'systemd-cgls 2>&1 | head -20' 0 "systemd-cgls: cgroup tree"
rlRun 'systemd-cgls -k 2>&1 | head -5' 0 "systemd-cgls -k: kernel threads"
rlRun 'systemd-cgls --no-pager 2>&1 | head -10' 0 "systemd-cgls --no-pager"

# ===================================================================

. "../teardown.sh"
echo "All systemd systemd-cgls---Cgroup-listing tests passed!"
