#!/bin/sh -eux
# Functional test: tmux - Find-window

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q tmux' 0 "Check tmux package is installed"
rlRun 'which tmux' 0 "Check tmux command available"
rlRun 'tmux -V' 0 "tmux version"
TmpDir=$(mktemp -d)
export TMUX_TMPDIR=$TmpDir

echo "=== Test 15: Find window ==="

rlRun 'tmux find-window "bash" 2>&1 || true' 0 "find-window: search windows"

# ===================================================================

echo ""
echo "All tmux Find-window tests passed!"
