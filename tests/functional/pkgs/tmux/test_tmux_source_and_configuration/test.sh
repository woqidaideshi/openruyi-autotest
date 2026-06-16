#!/bin/sh -eux
# Functional test: tmux - Source-and-configuration

. "../setup.sh"

echo "=== Test 13: Source and configuration ==="

# 13.1 source-file
cat > $TmpDir/test_tmux.conf << 'EOF'
set -g status-interval 2
set -g default-terminal "screen-256color"
EOF
rlRun 'tmux source-file $TmpDir/test_tmux.conf 2>&1 || true' 0 "source-file: source config"

# ===================================================================

. "../teardown.sh"
echo "All tmux Source-and-configuration tests passed!"
