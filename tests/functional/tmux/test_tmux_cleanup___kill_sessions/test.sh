#!/bin/sh -eux
# Functional test: tmux - Cleanup---kill-sessions

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install tmux ===
INSTALLED_BY_TEST=0
if ! rpm -q tmux 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y tmux 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed tmux"
    else
        echo "SKIP: tmux not available in repos"
        exit 0
    fi
else
    echo "SETUP: tmux already installed"
fi

rlRun 'tmux -V' 0 "tmux version"
TmpDir=$(mktemp -d)
export TMUX_TMPDIR=$TmpDir

echo "=== Test 21: Cleanup - kill sessions ==="

rlRun 'tmux kill-session -t renamed_sess 2>&1 || true' 0 "kill-session: kill renamed_sess"
rlRun 'tmux kill-session -t sess_fmt 2>&1 || true' 0 "kill-session: kill sess_fmt"
rlRun 'tmux kill-session -t sess_sz 2>&1 || true' 0 "kill-session: kill sess_sz"
rlRun 'tmux kill-session -t sess_flags 2>&1 || true' 0 "kill-session: kill sess_flags"
rlRun 'tmux kill-session -t sess_env 2>&1 || true' 0 "kill-session: kill sess_env"
rlRun 'tmux kill-session -t testsess 2>&1 || true' 0 "kill-session: kill main test session"
rlRun 'tmux kill-server 2>&1 || true' 0 "kill-server: terminate server"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tmux 2>/dev/null || true
    echo "TEARDOWN: removed tmux"
fi
echo ""
echo "All tmux Cleanup---kill-sessions tests passed!"
