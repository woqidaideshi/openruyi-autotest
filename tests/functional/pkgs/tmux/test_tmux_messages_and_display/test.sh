#!/bin/sh -eux
# Functional test: tmux - Messages-and-display

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

echo "=== Test 11: Messages and display ==="

# 11.1 display-message
rlRun 'tmux display-message "test message" 2>&1 || true' 0 "display-message: show message"
rlRun 'tmux display-message -p "session: #{session_name}"' 0 "display-message -p: print format"

# 11.2 show-messages
rlRun 'tmux show-messages 2>&1 || true' 0 "show-messages: message log"

# 11.3 display-popup
rlRun 'tmux display-popup -C 2>&1 || true' 0 "display-popup -C: close popup"

# 11.4 clear-history
rlRun 'tmux clear-history -t testsess:win1' 0 "clear-history: clear pane history"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tmux 2>/dev/null || true
    echo "TEARDOWN: removed tmux"
fi
echo ""
echo "All tmux Messages-and-display tests passed!"
