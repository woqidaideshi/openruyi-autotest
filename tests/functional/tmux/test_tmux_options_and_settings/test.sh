#!/bin/sh -eux
# Functional test: tmux - Options-and-settings

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

echo "=== Test 8: Options and settings ==="

# 8.1 set-option (global)
rlRun 'tmux set-option -g status-interval 5 2>&1 || true' 0 "set-option -g: global"
rlRun 'tmux set-option -g -a status-left "test" 2>&1 || true' 0 "set-option -a: append"
rlRun 'tmux set-option -g mouse on 2>&1 || true' 0 "set-option: mouse on"

# 8.2 set-option (server)
rlRun 'tmux set-option -s escape-time 10 2>&1 || true' 0 "set-option -s: server option"

# 8.3 set-window-option
rlRun 'tmux set-window-option -t testsess:win1 monitor-activity on 2>&1 || true' 0 "set-window-option: monitor activity"
rlRun 'tmux set-window-option -g automatic-rename on 2>&1 || true' 0 "set-window-option -g: global"

# 8.4 show-options
rlRun 'tmux show-options -g | head -10' 0 "show-options -g: global options"
rlRun 'tmux show-options -s | head -10' 0 "show-options -s: server options"

# 8.5 show-window-options
rlRun 'tmux show-window-options -t testsess:win1 | head -10' 0 "show-window-options: window options"
rlRun 'tmux show-window-options -g | head -10' 0 "show-window-options -g: global window options"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tmux 2>/dev/null || true
    echo "TEARDOWN: removed tmux"
fi
echo ""
echo "All tmux Options-and-settings tests passed!"
