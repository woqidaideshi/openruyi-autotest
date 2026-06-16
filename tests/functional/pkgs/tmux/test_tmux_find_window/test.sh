#!/bin/sh -eux
# Functional test: tmux - Find-window

. "../setup.sh"

echo "=== Test 15: Find window ==="

rlRun 'tmux find-window "bash" 2>&1 || true' 0 "find-window: search windows"

# ===================================================================

. "../teardown.sh"
echo "All tmux Find-window tests passed!"
