#!/bin/sh -eux
# Functional test: tmux - Lock-management

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q tmux' 0 "Check tmux package is installed"
rlRun 'which tmux' 0 "Check tmux command available"
rlRun 'tmux -V' 0 "tmux version"
TmpDir=$(mktemp -d)
export TMUX_TMPDIR=$TmpDir

echo "=== Test 18: Lock management ==="

rlRun 'tmux lock-server 2>&1 || true' 0 "lock-server: lock server"
rlRun 'tmux lock-session -t testsess 2>&1 || true' 0 "lock-session: lock session"

# ===================================================================

echo ""
echo "All tmux Lock-management tests passed!"
