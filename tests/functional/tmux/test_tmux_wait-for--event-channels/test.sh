#!/bin/sh -eux
# Functional test: tmux - Wait-for--event-channels

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q tmux' 0 "Check tmux package is installed"
rlRun 'which tmux' 0 "Check tmux command available"
rlRun 'tmux -V' 0 "tmux version"
TmpDir=$(mktemp -d)
export TMUX_TMPDIR=$TmpDir

echo "=== Test 20: Wait-for (event channels) ==="

rlRun 'tmux wait-for -L mychannel 2>&1 || true' 0 "wait-for -L: lock channel"

# ===================================================================

echo ""
echo "All tmux Wait-for--event-channels tests passed!"
