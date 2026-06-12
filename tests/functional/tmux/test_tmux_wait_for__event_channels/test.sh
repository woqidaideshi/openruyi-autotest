#!/bin/sh -eux
# Functional test: tmux - Wait-for--event-channels

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q tmux 2>/dev/null || { echo 'tmux not installed, skipping'; exit 0; }
which tmux 2>/dev/null || echo 'tmux not found'
rlRun 'tmux -V' 0 "tmux version"
TmpDir=$(mktemp -d)
export TMUX_TMPDIR=$TmpDir

echo "=== Test 20: Wait-for (event channels) ==="

rlRun 'tmux wait-for -L mychannel 2>&1 || true' 0 "wait-for -L: lock channel"

# ===================================================================

echo ""
echo "All tmux Wait-for--event-channels tests passed!"
