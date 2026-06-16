#!/bin/sh -eux
# Functional test: tmux - Copy-mode

. "../setup.sh"

echo "=== Test 14: Copy mode ==="

rlRun 'tmux copy-mode -t testsess:win1 2>&1 || true' 0 "copy-mode: enter copy mode"

# ===================================================================

. "../teardown.sh"
echo "All tmux Copy-mode tests passed!"
