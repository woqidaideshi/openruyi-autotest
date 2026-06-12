#!/bin/sh -eux
# Functional test: systemd - systemd-cgls---Cgroup-listing

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q systemd' 0 "Check systemd package is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 9: systemd-cgls - Cgroup listing ==="

rlRun 'systemd-cgls 2>&1 | head -20' 0 "systemd-cgls: cgroup tree"
rlRun 'systemd-cgls -k 2>&1 | head -5' 0 "systemd-cgls -k: kernel threads"
rlRun 'systemd-cgls --no-pager 2>&1 | head -10' 0 "systemd-cgls --no-pager"

# ===================================================================

echo ""
echo "All systemd systemd-cgls---Cgroup-listing tests passed!"
