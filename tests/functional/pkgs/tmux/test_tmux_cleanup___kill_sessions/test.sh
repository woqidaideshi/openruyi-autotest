#!/bin/sh -eux
# Functional test: tmux - Cleanup---kill-sessions

. "../setup.sh"

echo "=== Test 21: Cleanup - kill sessions ==="

rlRun 'tmux kill-session -t renamed_sess 2>&1 || true' 0 "kill-session: kill renamed_sess"
rlRun 'tmux kill-session -t sess_fmt 2>&1 || true' 0 "kill-session: kill sess_fmt"
rlRun 'tmux kill-session -t sess_sz 2>&1 || true' 0 "kill-session: kill sess_sz"
rlRun 'tmux kill-session -t sess_flags 2>&1 || true' 0 "kill-session: kill sess_flags"
rlRun 'tmux kill-session -t sess_env 2>&1 || true' 0 "kill-session: kill sess_env"
rlRun 'tmux kill-session -t testsess 2>&1 || true' 0 "kill-session: kill main test session"
rlRun 'tmux kill-server 2>&1 || true' 0 "kill-server: terminate server"

# ===================================================================

. "../teardown.sh"
echo "All tmux Cleanup---kill-sessions tests passed!"
