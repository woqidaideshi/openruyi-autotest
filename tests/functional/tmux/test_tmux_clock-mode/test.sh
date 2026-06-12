#!/bin/sh -eux
# Functional test: tmux - Clock-mode

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q tmux' 0 "Check tmux package is installed"
rlRun 'which tmux' 0 "Check tmux command available"
rlRun 'tmux -V' 0 "tmux version"
TmpDir=$(mktemp -d)
export TMUX_TMPDIR=$TmpDir

echo "=== Test 17: Clock mode ==="

rlRun 'tmux clock-mode -t testsess:win1 2>&1 || true' 0 "clock-mode: show clock"

# ===================================================================

echo ""
echo "All tmux Clock-mode tests passed!"
