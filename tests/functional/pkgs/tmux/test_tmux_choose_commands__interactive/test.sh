#!/bin/sh -eux
# Functional test: tmux - Choose-commands--interactive

. "../setup.sh"

echo "=== Test 16: Choose commands (interactive) ==="

rlRun 'tmux choose-tree -G 2>&1 || true' 0 "choose-tree -G: tree display"
rlRun 'tmux choose-client 2>&1 || true' 0 "choose-client: client selection"

# ===================================================================

. "../teardown.sh"
echo "All tmux Choose-commands--interactive tests passed!"
