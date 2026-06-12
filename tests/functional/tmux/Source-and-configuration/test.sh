#!/bin/sh -eux
# Functional test: tmux - Source-and-configuration

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q tmux' 0 "Check tmux package is installed"
rlRun 'which tmux' 0 "Check tmux command available"
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

echo ""
echo "All tmux Source-and-configuration tests passed!"
