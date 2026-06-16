#!/bin/sh -eux
# Functional test: tmux - Hooks

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

echo "=== Test 10: Hooks ==="

# 10.1 set-hook
rlRun 'tmux set-hook -g session-created "display-message created"' 0 "set-hook: session-created"
rlRun 'tmux set-hook -g client-attached "display-message attached"' 0 "set-hook: client-attached"

# 10.2 show-hooks
rlRun 'tmux show-hooks -g' 0 "show-hooks -g: global hooks"

# 10.3 remove hooks
rlRun 'tmux set-hook -gu session-created' 0 "set-hook -gu: remove global hook"
rlRun 'tmux set-hook -gu client-attached' 0 "set-hook -gu: remove hook"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tmux 2>/dev/null || true
    echo "TEARDOWN: removed tmux"
fi
echo ""
echo "All tmux Hooks tests passed!"
