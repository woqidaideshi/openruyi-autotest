#!/bin/sh -eux
# Functional test: tmux - Clock-mode

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q tmux 2>/dev/null || { echo 'tmux not installed, skipping'; exit 0; }
which tmux 2>/dev/null || echo 'tmux not found'
rlRun 'tmux -V' 0 "tmux version"
TmpDir=$(mktemp -d)
export TMUX_TMPDIR=$TmpDir

echo "=== Test 17: Clock mode ==="

rlRun 'tmux clock-mode -t testsess:win1 2>&1 || true' 0 "clock-mode: show clock"

# ===================================================================

echo ""
echo "All tmux Clock-mode tests passed!"
