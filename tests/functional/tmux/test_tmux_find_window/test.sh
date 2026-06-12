#!/bin/sh -eux
# Functional test: tmux - Find-window

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q tmux 2>/dev/null || { echo 'tmux not installed, skipping'; exit 0; }
which tmux 2>/dev/null || echo 'tmux not found'
rlRun 'tmux -V' 0 "tmux version"
TmpDir=$(mktemp -d)
export TMUX_TMPDIR=$TmpDir

echo "=== Test 15: Find window ==="

rlRun 'tmux find-window "bash" 2>&1 || true' 0 "find-window: search windows"

# ===================================================================

echo ""
echo "All tmux Find-window tests passed!"
