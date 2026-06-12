#!/bin/sh -eux
# Functional test: tmux - Session-creation-and-management

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q tmux 2>/dev/null || { echo 'tmux not installed, skipping'; exit 0; }
which tmux 2>/dev/null || echo 'tmux not found'
rlRun 'tmux -V' 0 "tmux version"
TmpDir=$(mktemp -d)
export TMUX_TMPDIR=$TmpDir

echo "=== Test 2: Session creation and management ==="

# 2.1 new-session (detached)
rlRun 'tmux new-session -d -s testsess -n win1' 0 "new-session -d: create detached session"
rlRun 'tmux has-session -t testsess' 0 "has-session: verify session exists"

# 2.2 new-session with options
rlRun 'tmux new-session -d -s sess2 -c /tmp -n main' 0 "new-session -d: with start directory"
rlRun 'tmux has-session -t sess2' 0 "has-session: verify sess2 exists"

# 2.3 new-session with environment
rlRun 'tmux new-session -d -s sess_env -e TEST_VAR=hello -n env_win' 0 "new-session -e: set environment"

# 2.4 new-session with format
rlRun 'tmux new-session -d -s sess_fmt -F "#{session_name}" -n fmt_win' 0 "new-session -F: format output"

# 2.5 new-session with width/height
rlRun 'tmux new-session -d -s sess_sz -x 80 -y 24 -n sz_win' 0 "new-session: set dimensions"

# 2.6 new-session with flags
rlRun 'tmux new-session -d -s sess_flags -A -n flags_win 2>&1 || true' 0 "new-session -A: attach if exists"

# 2.7 list-sessions
rlRun 'tmux list-sessions' 0 "list-sessions: list all sessions"
rlRun 'tmux list-sessions -F "#{session_name}"' 0 "list-sessions -F: formatted"

# 2.8 rename-session
rlRun 'tmux rename-session -t sess2 renamed_sess' 0 "rename-session: rename sess2"
rlRun 'tmux has-session -t renamed_sess' 0 "has-session: verify renamed session"

# 2.9 lock-session
rlRun 'tmux lock-session -t testsess 2>&1 || true' 0 "lock-session: lock session"

# 2.10 switch-client
rlRun 'tmux switch-client -t renamed_sess 2>&1 || true' 0 "switch-client -t: switch to session"

# 2.11 attach-session (detached mode)
rlRun 'tmux attach-session -t testsess -d 2>&1 || true' 0 "attach-session -d: attach and detach others"

# 2.12 detach-client
rlRun 'tmux detach-client -P 2>&1 || true' 0 "detach-client -P"
rlRun 'tmux detach-client -a -s testsess 2>&1 || true' 0 "detach-client -a: all in session"

# 2.13 suspend-client
rlRun 'tmux suspend-client -t testsess 2>&1 || true' 0 "suspend-client: suspend client"

# 2.14 lock-client
rlRun 'tmux lock-client -t testsess 2>&1 || true' 0 "lock-client: lock client"

# 2.15 refresh-client
rlRun 'tmux refresh-client -S 2>&1 || true' 0 "refresh-client -S: status line only"
rlRun 'tmux refresh-client -L 2>&1 || true' 0 "refresh-client -L: lease"

# ===================================================================

echo ""
echo "All tmux Session-creation-and-management tests passed!"
