#!/bin/sh -eux
# Functional test: tmux - Hooks

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q tmux' 0 "Check tmux package is installed"
rlRun 'which tmux' 0 "Check tmux command available"
rlRun 'tmux -V' 0 "tmux version"
TmpDir=$(mktemp -d)
export TMUX_TMPDIR=$TmpDir

echo "=== Test 10: Hooks ==="

# 10.1 set-hook
rlRun 'tmux set-hook -g session-created "display-message created"' 0 "set-hook: session-created"
rlRun 'tmux set-hook -g client-attached "display-message attached"' 0 "set-hook: client-attached"

# 10.2 show-hooks
rlRun 'tmux show-hooks -g' 0 "show-hooks -g: global hooks"

# 10.3 remove hooks
rlRun 'tmux set-hook -gu session-created' 0 "set-hook -gu: remove global hook"
rlRun 'tmux set-hook -gu client-attached' 0 "set-hook -gu: remove hook"

# ===================================================================

echo ""
echo "All tmux Hooks tests passed!"
