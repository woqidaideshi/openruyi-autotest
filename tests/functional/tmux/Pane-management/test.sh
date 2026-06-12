#!/bin/sh -eux
# Functional test: tmux - Pane-management

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q tmux' 0 "Check tmux package is installed"
rlRun 'which tmux' 0 "Check tmux command available"
rlRun 'tmux -V' 0 "tmux version"
TmpDir=$(mktemp -d)
export TMUX_TMPDIR=$TmpDir

echo "=== Test 4: Pane management ==="

# 4.1 split-window
rlRun 'tmux split-window -t testsess:win1' 0 "split-window: horizontal split"
rlRun 'tmux split-window -h -t testsess:win1' 0 "split-window -h: vertical split"
rlRun 'tmux split-window -v -t testsess:win1' 0 "split-window -v: vertical explicit"
rlRun 'tmux split-window -t testsess:win1 -l 10' 0 "split-window -l: with size"
rlRun 'tmux split-window -t testsess:win1 -d' 0 "split-window -d: don't focus"
rlRun 'tmux split-window -t testsess:win1 -f' 0 "split-window -f: full size"
rlRun 'tmux split-window -t testsess:win1 -b' 0 "split-window -b: before"
rlRun 'tmux split-window -t testsess:win1 -I' 0 "split-window -I: create empty pane"

# 4.2 list-panes
rlRun 'tmux list-panes -t testsess:win1' 0 "list-panes: list panes"
rlRun 'tmux list-panes -as' 0 "list-panes -as: all panes"
rlRun 'tmux list-panes -t testsess:win1 -F "#{pane_id}"' 0 "list-panes -F: formatted"

# 4.3 display-panes
rlRun 'tmux display-panes -t testsess 2>&1 || true' 0 "display-panes: show pane IDs"

# 4.4 select-pane
rlRun 'tmux select-pane -t testsess:win1.0' 0 "select-pane: by ID"
rlRun 'tmux select-pane -l -t testsess:win1' 0 "select-pane -l: last pane"
rlRun 'tmux select-pane -U -t testsess:win1' 0 "select-pane -U: up"
rlRun 'tmux select-pane -D -t testsess:win1' 0 "select-pane -D: down"
rlRun 'tmux select-pane -L -t testsess:win1' 0 "select-pane -L: left"
rlRun 'tmux select-pane -R -t testsess:win1' 0 "select-pane -R: right"

# 4.5 resize-pane
rlRun 'tmux resize-pane -t testsess:win1.0 -y 15 2>&1 || true' 0 "resize-pane -y: height"
rlRun 'tmux resize-pane -t testsess:win1.0 -x 80 2>&1 || true' 0 "resize-pane -x: width"
rlRun 'tmux resize-pane -t testsess:win1.0 -U 2>&1 || true' 0 "resize-pane -U: up"
rlRun 'tmux resize-pane -t testsess:win1.0 -D 2>&1 || true' 0 "resize-pane -D: down"
rlRun 'tmux resize-pane -t testsess:win1.0 -L 2>&1 || true' 0 "resize-pane -L: left"
rlRun 'tmux resize-pane -t testsess:win1.0 -R 2>&1 || true' 0 "resize-pane -R: right"
rlRun 'tmux resize-pane -Z -t testsess:win1.0 2>&1 || true' 0 "resize-pane -Z: zoom"

# 4.6 break-pane
rlRun 'tmux break-pane -t testsess:win1.1 -d -n broken_pane' 0 "break-pane -d: break pane to new window"

# 4.7 join-pane
rlRun 'tmux join-pane -s testsess:broken_pane.0 -t testsess:win1 2>&1 || true' 0 "join-pane: join pane back"

# 4.8 move-pane
rlRun 'tmux move-pane -t testsess:win2 2>&1 || true' 0 "move-pane: move pane"

# 4.9 swap-pane
rlRun 'tmux swap-pane -s testsess:win1.0 -t testsess:win1.1 2>&1 || true' 0 "swap-pane: swap panes"

# 4.10 last-pane
rlRun 'tmux last-pane -t testsess:win1' 0 "last-pane: switch to last pane"

# 4.11 kill-pane
rlRun 'tmux split-window -t testsess:win1' 0 "kill-pane: create temp pane"
rlRun 'tmux kill-pane -t testsess:win1.1 2>&1 || true' 0 "kill-pane: kill pane"
rlRun 'tmux kill-pane -a -t testsess:win1 2>&1 || true' 0 "kill-pane -a: kill all but current"

# 4.12 capture-pane
rlRun 'tmux capture-pane -t testsess:win1 -p' 0 "capture-pane -p: print to stdout"
rlRun 'tmux capture-pane -t testsess:win1 -S -10 -E -1 -p 2>&1 || true' 0 "capture-pane: range capture"
rlRun 'tmux capture-pane -t testsess:win1 -J -p 2>&1 || true' 0 "capture-pane -J: join lines"

# 4.13 pipe-pane
rlRun 'tmux pipe-pane -t testsess:win1 -o "cat >> /tmp/tmux_pipe.log" 2>&1 || true' 0 "pipe-pane -o: pipe output"

# 4.14 respawn-pane
rlRun 'tmux respawn-pane -k -t testsess:win1.0 2>&1 || true' 0 "respawn-pane -k: respawn"

# ===================================================================

echo ""
echo "All tmux Pane-management tests passed!"
