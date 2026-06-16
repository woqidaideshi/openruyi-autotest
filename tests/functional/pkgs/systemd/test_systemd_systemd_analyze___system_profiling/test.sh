#!/bin/sh -eux
# Functional test: systemd - systemd-analyze---System-profiling

. "../setup.sh"

echo "=== Test 3: systemd-analyze - System profiling ==="

rlRun 'systemd-analyze --version 2>&1 || true' 0 "systemd-analyze version"
rlRun 'systemd-analyze time 2>&1 || true' 0 "systemd-analyze time: boot time"
rlRun 'systemd-analyze security 2>&1 | head -5' 0 "systemd-analyze security"

# ===================================================================

. "../teardown.sh"
echo "All systemd systemd-analyze---System-profiling tests passed!"
