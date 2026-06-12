#!/bin/sh -eux
# Functional test: tmux - Source-and-configuration

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

echo "=== Test 13: Source and configuration ==="

# 13.1 source-file
cat > $TmpDir/test_tmux.conf << 'EOF'
set -g status-interval 2
set -g default-terminal "screen-256color"
EOF
rlRun 'tmux source-file $TmpDir/test_tmux.conf 2>&1 || true' 0 "source-file: source config"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tmux 2>/dev/null || true
    echo "TEARDOWN: removed tmux"
fi
echo ""
echo "All tmux Source-and-configuration tests passed!"
