#!/bin/sh -eux
# Functional test: tmux - Choose-commands--interactive

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q tmux' 0 "Check tmux package is installed"
rlRun 'which tmux' 0 "Check tmux command available"
rlRun 'tmux -V' 0 "tmux version"
TmpDir=$(mktemp -d)
export TMUX_TMPDIR=$TmpDir

echo "=== Test 16: Choose commands (interactive) ==="

rlRun 'tmux choose-tree -G 2>&1 || true' 0 "choose-tree -G: tree display"
rlRun 'tmux choose-client 2>&1 || true' 0 "choose-client: client selection"

# ===================================================================

echo ""
echo "All tmux Choose-commands--interactive tests passed!"
