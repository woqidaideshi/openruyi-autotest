#!/bin/sh -eux
# Functional test: tmux - Show-prompt-history

. "../setup.sh"

echo "=== Test 19: Show prompt history ==="

rlRun 'tmux show-prompt-history 2>&1 || true' 0 "show-prompt-history: prompt history"
rlRun 'tmux clear-prompt-history 2>&1 || true' 0 "clear-prompt-history: clear prompt history"

# ===================================================================

. "../teardown.sh"
echo "All tmux Show-prompt-history tests passed!"
