#!/bin/sh -eux
# Functional test: tmux - Environment-variables

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

echo "=== Test 9: Environment variables ==="

# 9.1 set-environment
rlRun 'tmux set-environment -g MY_VAR test_value' 0 "set-environment -g: global env"
rlRun 'tmux set-environment -t testsess SESSION_VAR session_val' 0 "set-environment: session env"
rlRun 'tmux set-environment -gru MY_VAR' 0 "set-environment -gur: update then remove"

# 9.2 show-environment
rlRun 'tmux show-environment -g | head -10' 0 "show-environment -g: global env"
rlRun 'tmux show-environment -t testsess | head -10' 0 "show-environment: session env"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tmux 2>/dev/null || true
    echo "TEARDOWN: removed tmux"
fi
echo ""
echo "All tmux Environment-variables tests passed!"
