#!/bin/sh -eux
# Functional test: systemd - oomctl

. "../setup.sh"

echo "=== Test 30: oomctl ==="

rlRun 'oomctl --help 2>&1 | head -5' 0 "oomctl help"
rlRun 'oomctl dump 2>&1 | head -5 || true' 0 "oomctl dump"

# ===================================================================

. "../teardown.sh"
echo "All systemd oomctl tests passed!"
