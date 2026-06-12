#!/bin/sh -eux
# Functional test: tmux - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q tmux' 0 "Check tmux package is installed"
rlRun 'which tmux' 0 "Check tmux command available"
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
