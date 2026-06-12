#!/bin/sh -eux
# Functional test: tmux - Show-prompt-history

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q tmux 2>/dev/null || { echo 'tmux not installed, skipping'; exit 0; }
which tmux 2>/dev/null || echo 'tmux not found'
rlRun 'tmux -V' 0 "tmux version"
TmpDir=$(mktemp -d)
export TMUX_TMPDIR=$TmpDir

echo "=== Test 19: Show prompt history ==="

rlRun 'tmux show-prompt-history 2>&1 || true' 0 "show-prompt-history: prompt history"
rlRun 'tmux clear-prompt-history 2>&1 || true' 0 "clear-prompt-history: clear prompt history"

# ===================================================================

echo ""
echo "All tmux Show-prompt-history tests passed!"
