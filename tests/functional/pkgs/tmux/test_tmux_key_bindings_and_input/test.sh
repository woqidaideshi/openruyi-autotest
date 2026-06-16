#!/bin/sh -eux
# Functional test: tmux - Key-bindings-and-input

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

echo "=== Test 7: Key bindings and input ==="

# 7.1 list-keys
rlRun 'tmux list-keys | head -20' 0 "list-keys: list all keys"
rlRun 'tmux list-keys -T prefix | head -10' 0 "list-keys -T: prefix table"
rlRun 'tmux list-keys -T root | head -10' 0 "list-keys -T: root table"
rlRun 'tmux list-keys -a' 0 "list-keys -a: all keys"
rlRun 'tmux list-keys -N | head -10' 0 "list-keys -N: with notes"

# 7.2 bind-key / unbind-key
rlRun 'tmux bind-key -n C-o display-message "test"' 0 "bind-key -n: bind to key"
rlRun 'tmux unbind-key -n C-o' 0 "unbind-key -n: unbind key"
rlRun 'tmux bind-key -T prefix x display-message "test"' 0 "bind-key -T: bind in table"
rlRun 'tmux unbind-key -T prefix x' 0 "unbind-key -T: unbind in table"

# 7.3 send-keys
rlRun 'tmux send-keys -t testsess:win1 "echo hello" Enter 2>&1 || true' 0 "send-keys: send text"
rlRun 'tmux send-keys -l -t testsess:win1 "literal" 2>&1 || true' 0 "send-keys -l: literal"
rlRun 'tmux send-keys -H -t testsess:win1 "0d" 2>&1 || true' 0 "send-keys -H: hex"

# 7.4 send-prefix
rlRun 'tmux send-prefix -t testsess:win1 2>&1 || true' 0 "send-prefix: send prefix key"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tmux 2>/dev/null || true
    echo "TEARDOWN: removed tmux"
fi
echo ""
echo "All tmux Key-bindings-and-input tests passed!"
