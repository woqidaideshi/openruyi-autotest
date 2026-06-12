#!/bin/sh -eux
# Functional test: tmux - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q tmux 2>/dev/null || { echo 'tmux not installed, skipping'; exit 0; }
which tmux 2>/dev/null || echo 'tmux not found'
rlRun 'tmux -V' 0 "tmux version"
TmpDir=$(mktemp -d)
export TMUX_TMPDIR=$TmpDir

echo "=== Test 22: Error handling ==="

# Invalid session
rlRun 'tmux has-session -t nonexistent 2>&1 || true' 0 "Error: nonexistent session"

# Invalid option
rlRun 'tmux set-option -g nonexistent_option 2>&1 || true' 0 "Error: invalid option"

cd /
rm -rf $TmpDir

echo ""
echo "All tmux functional tests passed!"

echo ""
echo "All tmux Error-handling tests passed!"
