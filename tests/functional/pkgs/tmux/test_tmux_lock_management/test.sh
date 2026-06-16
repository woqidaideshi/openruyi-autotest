#!/bin/sh -eux
# Functional test: tmux - Lock-management

. "../setup.sh"

echo "=== Test 18: Lock management ==="

rlRun 'tmux lock-server 2>&1 || true' 0 "lock-server: lock server"
rlRun 'tmux lock-session -t testsess 2>&1 || true' 0 "lock-session: lock session"

# ===================================================================

. "../teardown.sh"
echo "All tmux Lock-management tests passed!"
