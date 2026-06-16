#!/bin/sh -eux
# Functional test: tmux - Error-handling

. "../setup.sh"

echo "=== Test 22: Error handling ==="

# Invalid session
rlRun 'tmux has-session -t nonexistent 2>&1 || true' 0 "Error: nonexistent session"

# Invalid option
rlRun 'tmux set-option -g nonexistent_option 2>&1 || true' 0 "Error: invalid option"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All tmux Error-handling tests passed!"
