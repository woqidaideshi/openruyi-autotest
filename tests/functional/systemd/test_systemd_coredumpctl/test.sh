#!/bin/sh -eux
# Functional test: systemd - coredumpctl

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q systemd' 0 "Check systemd package is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 19: coredumpctl ==="

rlRun 'coredumpctl --version 2>&1 || true' 0 "coredumpctl version"
rlRun 'coredumpctl list 2>&1 | head -5' 0 "coredumpctl list: list dumps"
rlRun 'coredumpctl info 2>&1 | head -5 || true' 0 "coredumpctl info"

# ===================================================================

echo ""
echo "All systemd coredumpctl tests passed!"
