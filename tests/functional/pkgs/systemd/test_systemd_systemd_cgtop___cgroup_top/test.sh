#!/bin/sh -eux
# Functional test: systemd - systemd-cgtop---Cgroup-top

. "../setup.sh"

echo "=== Test 10: systemd-cgtop - Cgroup top ==="

rlRun 'systemd-cgtop -n 1 -b 2>&1 | head -15' 0 "systemd-cgtop -b: batch mode"

# ===================================================================

. "../teardown.sh"
echo "All systemd systemd-cgtop---Cgroup-top tests passed!"
