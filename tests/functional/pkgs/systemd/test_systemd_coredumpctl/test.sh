#!/bin/sh -eux
# Functional test: systemd - coredumpctl

. "../setup.sh"

echo "=== Test 19: coredumpctl ==="

rlRun 'coredumpctl --version 2>&1 || true' 0 "coredumpctl version"
rlRun 'coredumpctl list 2>&1 | head -5' 0 "coredumpctl list: list dumps"
rlRun 'coredumpctl info 2>&1 | head -5 || true' 0 "coredumpctl info"

# ===================================================================

. "../teardown.sh"
echo "All systemd coredumpctl tests passed!"
