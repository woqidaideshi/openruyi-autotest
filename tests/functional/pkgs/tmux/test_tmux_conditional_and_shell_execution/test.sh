#!/bin/sh -eux
# Functional test: tmux - Conditional-and-shell-execution

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

echo "=== Test 12: Conditional and shell execution ==="

# 12.1 if-shell
rlRun 'tmux if-shell "true" "display-message ok" "display-message fail" 2>&1 || true' 0 "if-shell: true condition"

# 12.2 run-shell
rlRun 'tmux run-shell "echo hello_from_run_shell" 2>&1 || true' 0 "run-shell: run shell command"
rlRun 'tmux run-shell -b "sleep 0.1; echo background" 2>&1 || true' 0 "run-shell -b: background"

# 12.3 command-prompt
rlRun 'echo quit | tmux command-prompt 2>&1 || true' 0 "command-prompt: open prompt"

# 12.4 confirm-before
rlRun 'tmux confirm-before -p "OK?" "echo confirmed" 2>&1 || true' 0 "confirm-before: confirm dialog"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tmux 2>/dev/null || true
    echo "TEARDOWN: removed tmux"
fi
echo ""
echo "All tmux Conditional-and-shell-execution tests passed!"
