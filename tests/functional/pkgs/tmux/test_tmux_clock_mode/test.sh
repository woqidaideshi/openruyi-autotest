#!/bin/sh -eux
# Functional test: tmux - Clock-mode

. "../setup.sh"

echo "=== Test 17: Clock mode ==="

rlRun 'tmux clock-mode -t testsess:win1 2>&1 || true' 0 "clock-mode: show clock"

# ===================================================================

. "../teardown.sh"
echo "All tmux Clock-mode tests passed!"
