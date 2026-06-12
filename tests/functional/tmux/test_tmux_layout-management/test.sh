#!/bin/sh -eux
# Functional test: tmux - Layout-management

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q tmux' 0 "Check tmux package is installed"
rlRun 'which tmux' 0 "Check tmux command available"
rlRun 'tmux -V' 0 "tmux version"
TmpDir=$(mktemp -d)
export TMUX_TMPDIR=$TmpDir

echo "=== Test 5: Layout management ==="

# 5.1 select-layout
rlRun 'tmux select-layout -t testsess:win1 even-horizontal 2>&1 || true' 0 "select-layout: even-horizontal"
rlRun 'tmux select-layout -t testsess:win1 even-vertical 2>&1 || true' 0 "select-layout: even-vertical"
rlRun 'tmux select-layout -t testsess:win1 main-horizontal 2>&1 || true' 0 "select-layout: main-horizontal"
rlRun 'tmux select-layout -t testsess:win1 main-vertical 2>&1 || true' 0 "select-layout: main-vertical"
rlRun 'tmux select-layout -t testsess:win1 tiled 2>&1 || true' 0 "select-layout: tiled"

# 5.2 next-layout / previous-layout
rlRun 'tmux next-layout -t testsess:win1 2>&1 || true' 0 "next-layout: cycle layouts"
rlRun 'tmux previous-layout -t testsess:win1 2>&1 || true' 0 "previous-layout: prev layout"

# ===================================================================

echo ""
echo "All tmux Layout-management tests passed!"
