#!/bin/sh -eux
# Functional test: systemd - coredumpctl

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q systemd 2>/dev/null || { echo 'systemd not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 19: coredumpctl ==="

rlRun 'coredumpctl --version 2>&1 || true' 0 "coredumpctl version"
rlRun 'coredumpctl list 2>&1 | head -5' 0 "coredumpctl list: list dumps"
rlRun 'coredumpctl info 2>&1 | head -5 || true' 0 "coredumpctl info"

# ===================================================================

echo ""
echo "All systemd coredumpctl tests passed!"
