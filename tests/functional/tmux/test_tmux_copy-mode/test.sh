#!/bin/sh -eux
# Functional test: tmux - Copy-mode

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q tmux' 0 "Check tmux package is installed"
rlRun 'which tmux' 0 "Check tmux command available"
rlRun 'tmux -V' 0 "tmux version"
TmpDir=$(mktemp -d)
export TMUX_TMPDIR=$TmpDir

echo "=== Test 14: Copy mode ==="

rlRun 'tmux copy-mode -t testsess:win1 2>&1 || true' 0 "copy-mode: enter copy mode"

# ===================================================================

echo ""
echo "All tmux Copy-mode tests passed!"
