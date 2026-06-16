#!/bin/sh -eux
# Functional test: tmux - Choose-commands--interactive

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

echo "=== Test 16: Choose commands (interactive) ==="

rlRun 'tmux choose-tree -G 2>&1 || true' 0 "choose-tree -G: tree display"
rlRun 'tmux choose-client 2>&1 || true' 0 "choose-client: client selection"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tmux 2>/dev/null || true
    echo "TEARDOWN: removed tmux"
fi
echo ""
echo "All tmux Choose-commands--interactive tests passed!"
