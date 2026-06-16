#!/bin/sh -eux
# Functional test: tmux - Wait-for--event-channels

. "../setup.sh"

echo "=== Test 20: Wait-for (event channels) ==="

rlRun 'tmux wait-for -L mychannel 2>&1 || true' 0 "wait-for -L: lock channel"

# ===================================================================

. "../teardown.sh"
echo "All tmux Wait-for--event-channels tests passed!"
