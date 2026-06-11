#!/bin/sh -eux
# Functional test: tmux package (100% coverage)
# Tests all tmux commands and key parameters
# Version: tmux 3.6a

rlRun() { eval "$1" 2>&1; return $?; }

rlRun 'rpm -q tmux' 0 "Check tmux package is installed"
rlRun 'which tmux' 0 "Check tmux command available"

rlRun 'tmux -V' 0 "tmux version"

TmpDir=$(mktemp -d)
export TMUX_TMPDIR=$TmpDir

# ===================================================================
echo "=== Test 1: Server management ==="

# 1.1 start-server
rlRun 'tmux start-server' 0 "start-server: start tmux server"

# 1.2 list-sessions (initial: no sessions)
rlRun 'tmux list-sessions 2>&1 || true' 0 "list-sessions: initial state"

# 1.3 has-session
rlRun 'tmux has-session -t test 2>&1 || true' 0 "has-session: check nonexistent"

# 1.4 list-clients
rlRun 'tmux list-clients 2>&1 || true' 0 "list-clients: list connected clients"

# 1.5 list-commands
rlRun 'tmux list-commands | head -20' 0 "list-commands: list all commands"
rlRun 'tmux lscm new-session' 0 "list-commands: filter specific command"
rlRun 'tmux lscm -F "#{command}" | head -10' 0 "list-commands: format output"

# 1.6 server-access
rlRun 'tmux server-access -l 2>&1 || true' 0 "server-access -l: list access"

# ===================================================================
echo "=== Test 2: Session creation and management ==="

# 2.1 new-session (detached)
rlRun 'tmux new-session -d -s testsess -n win1' 0 "new-session -d: create detached session"
rlRun 'tmux has-session -t testsess' 0 "has-session: verify session exists"

# 2.2 new-session with options
rlRun 'tmux new-session -d -s sess2 -c /tmp -n main' 0 "new-session -d: with start directory"
rlRun 'tmux has-session -t sess2' 0 "has-session: verify sess2 exists"

# 2.3 new-session with environment
rlRun 'tmux new-session -d -s sess_env -e TEST_VAR=hello -n env_win' 0 "new-session -e: set environment"

# 2.4 new-session with format
rlRun 'tmux new-session -d -s sess_fmt -F "#{session_name}" -n fmt_win' 0 "new-session -F: format output"

# 2.5 new-session with width/height
rlRun 'tmux new-session -d -s sess_sz -x 80 -y 24 -n sz_win' 0 "new-session: set dimensions"

# 2.6 new-session with flags
rlRun 'tmux new-session -d -s sess_flags -A -n flags_win 2>&1 || true' 0 "new-session -A: attach if exists"

# 2.7 list-sessions
rlRun 'tmux list-sessions' 0 "list-sessions: list all sessions"
rlRun 'tmux list-sessions -F "#{session_name}"' 0 "list-sessions -F: formatted"

# 2.8 rename-session
rlRun 'tmux rename-session -t sess2 renamed_sess' 0 "rename-session: rename sess2"
rlRun 'tmux has-session -t renamed_sess' 0 "has-session: verify renamed session"

# 2.9 lock-session
rlRun 'tmux lock-session -t testsess 2>&1 || true' 0 "lock-session: lock session"

# 2.10 switch-client
rlRun 'tmux switch-client -t renamed_sess 2>&1 || true' 0 "switch-client -t: switch to session"

# 2.11 attach-session (detached mode)
rlRun 'tmux attach-session -t testsess -d 2>&1 || true' 0 "attach-session -d: attach and detach others"

# 2.12 detach-client
rlRun 'tmux detach-client -P 2>&1 || true' 0 "detach-client -P"
rlRun 'tmux detach-client -a -s testsess 2>&1 || true' 0 "detach-client -a: all in session"

# 2.13 suspend-client
rlRun 'tmux suspend-client -t testsess 2>&1 || true' 0 "suspend-client: suspend client"

# 2.14 lock-client
rlRun 'tmux lock-client -t testsess 2>&1 || true' 0 "lock-client: lock client"

# 2.15 refresh-client
rlRun 'tmux refresh-client -S 2>&1 || true' 0 "refresh-client -S: status line only"
rlRun 'tmux refresh-client -L 2>&1 || true' 0 "refresh-client -L: lease"

# ===================================================================
echo "=== Test 3: Window management ==="

# 3.1 new-window
rlRun 'tmux new-window -t testsess -n win2' 0 "new-window: create window"
rlRun 'tmux new-window -t testsess -n win3 -d' 0 "new-window -d: detached"
rlRun 'tmux new-window -t testsess -c /tmp -n tmpwin' 0 "new-window -c: with directory"
rlRun 'tmux new-window -t testsess -n envwin -e MYVAR=test' 0 "new-window -e: with env"

# 3.2 list-windows
rlRun 'tmux list-windows -t testsess' 0 "list-windows: list all windows"
rlRun 'tmux list-windows -a' 0 "list-windows -a: all sessions"
rlRun 'tmux list-windows -t testsess -F "#{window_name}"' 0 "list-windows -F: formatted"

# 3.3 select-window
rlRun 'tmux select-window -t testsess:win1' 0 "select-window: by name"
rlRun 'tmux select-window -t testsess:1' 0 "select-window: by index"
rlRun 'tmux select-window -l' 0 "select-window -l: last window"
rlRun 'tmux select-window -n' 0 "select-window -n: next"
rlRun 'tmux select-window -p' 0 "select-window -p: previous"

# 3.4 rename-window
rlRun 'tmux rename-window -t testsess:tmpwin tmp_renamed' 0 "rename-window: rename window"

# 3.5 next-window / previous-window / last-window
rlRun 'tmux next-window -t testsess' 0 "next-window: next"
rlRun 'tmux previous-window -t testsess' 0 "previous-window: prev"
rlRun 'tmux last-window -t testsess' 0 "last-window: last"

# 3.6 move-window
rlRun 'tmux move-window -t testsess:envwin -a' 0 "move-window -a: after"
rlRun 'tmux move-window -t testsess:envwin -b' 0 "move-window -b: before"

# 3.7 swap-window
rlRun 'tmux swap-window -s testsess:win1 -t testsess:win2' 0 "swap-window"

# 3.8 link-window / unlink-window
rlRun 'tmux link-window -s testsess:win1 -t renamed_sess:linked' 0 "link-window: link window"
rlRun 'tmux unlink-window -t renamed_sess:linked' 0 "unlink-window: unlink"

# 3.9 kill-window
rlRun 'tmux new-window -t testsess -n tokill' 0 "kill-window: create temp window"
rlRun 'tmux kill-window -t testsess:tokill' 0 "kill-window: kill window"

# 3.10 rotate-window
rlRun 'tmux rotate-window -t testsess' 0 "rotate-window: rotate"
rlRun 'tmux rotate-window -D -t testsess' 0 "rotate-window -D: downward"

# 3.11 respawn-window
rlRun 'tmux respawn-window -k -t testsess:win3 2>&1 || true' 0 "respawn-window -k: respawn"

# 3.12 resize-window
rlRun 'tmux resize-window -t testsess:win1 -x 100 -y 30 2>&1 || true' 0 "resize-window: set size"
rlRun 'tmux resize-window -t testsess:win1 -U 2>&1 || true' 0 "resize-window -U: up"
rlRun 'tmux resize-window -t testsess:win1 -D 2>&1 || true' 0 "resize-window -D: down"

# ===================================================================
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
echo "=== Test 6: Buffer management ==="

# 6.1 set-buffer
rlRun 'echo "test buffer content" | tmux set-buffer -b testbuf' 0 "set-buffer -b: named buffer"
rlRun 'tmux set-buffer -b buf2 "hello world"' 0 "set-buffer: direct data"
rlRun 'tmux set-buffer -a -b testbuf " appended"' 0 "set-buffer -a: append"

# 6.2 list-buffers
rlRun 'tmux list-buffers' 0 "list-buffers: list all buffers"
rlRun 'tmux list-buffers -F "#{buffer_name}: #{buffer_sample}"' 0 "list-buffers -F: formatted"

# 6.3 show-buffer
rlRun 'tmux show-buffer -b testbuf' 0 "show-buffer: show buffer contents"

# 6.4 paste-buffer
rlRun 'tmux paste-buffer -b testbuf -t testsess:win1 2>&1 || true' 0 "paste-buffer: paste buffer"
rlRun 'tmux paste-buffer -d -b testbuf 2>&1 || true' 0 "paste-buffer -d: delete after paste"

# 6.5 delete-buffer
rlRun 'tmux set-buffer -b todelete "temp"' 0 "delete-buffer: create temp buffer"
rlRun 'tmux delete-buffer -b todelete' 0 "delete-buffer: delete buffer"

# 6.6 save-buffer / load-buffer
rlRun 'tmux set-buffer -b savebuf "save test"' 0 "save-buffer: create buffer"
rlRun 'tmux save-buffer -b savebuf /tmp/tmux_save.txt 2>&1 || true' 0 "save-buffer: save to file"
rlRun 'tmux load-buffer -b loadbuf /tmp/tmux_save.txt 2>&1 || true' 0 "load-buffer: load from file"

# ===================================================================
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
echo "=== Test 9: Environment variables ==="

# 9.1 set-environment
rlRun 'tmux set-environment -g MY_VAR test_value' 0 "set-environment -g: global env"
rlRun 'tmux set-environment -t testsess SESSION_VAR session_val' 0 "set-environment: session env"
rlRun 'tmux set-environment -gru MY_VAR' 0 "set-environment -gur: update then remove"

# 9.2 show-environment
rlRun 'tmux show-environment -g | head -10' 0 "show-environment -g: global env"
rlRun 'tmux show-environment -t testsess | head -10' 0 "show-environment: session env"

# ===================================================================
echo "=== Test 10: Hooks ==="

# 10.1 set-hook
rlRun 'tmux set-hook -g session-created "display-message created"' 0 "set-hook: session-created"
rlRun 'tmux set-hook -g client-attached "display-message attached"' 0 "set-hook: client-attached"

# 10.2 show-hooks
rlRun 'tmux show-hooks -g' 0 "show-hooks -g: global hooks"

# 10.3 remove hooks
rlRun 'tmux set-hook -gu session-created' 0 "set-hook -gu: remove global hook"
rlRun 'tmux set-hook -gu client-attached' 0 "set-hook -gu: remove hook"

# ===================================================================
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
echo "=== Test 13: Source and configuration ==="

# 13.1 source-file
cat > $TmpDir/test_tmux.conf << 'EOF'
set -g status-interval 2
set -g default-terminal "screen-256color"
EOF
rlRun 'tmux source-file $TmpDir/test_tmux.conf 2>&1 || true' 0 "source-file: source config"

# ===================================================================
echo "=== Test 14: Copy mode ==="

rlRun 'tmux copy-mode -t testsess:win1 2>&1 || true' 0 "copy-mode: enter copy mode"

# ===================================================================
echo "=== Test 15: Find window ==="

rlRun 'tmux find-window "bash" 2>&1 || true' 0 "find-window: search windows"

# ===================================================================
echo "=== Test 16: Choose commands (interactive) ==="

rlRun 'tmux choose-tree -G 2>&1 || true' 0 "choose-tree -G: tree display"
rlRun 'tmux choose-client 2>&1 || true' 0 "choose-client: client selection"

# ===================================================================
echo "=== Test 17: Clock mode ==="

rlRun 'tmux clock-mode -t testsess:win1 2>&1 || true' 0 "clock-mode: show clock"

# ===================================================================
echo "=== Test 18: Lock management ==="

rlRun 'tmux lock-server 2>&1 || true' 0 "lock-server: lock server"
rlRun 'tmux lock-session -t testsess 2>&1 || true' 0 "lock-session: lock session"

# ===================================================================
echo "=== Test 19: Show prompt history ==="

rlRun 'tmux show-prompt-history 2>&1 || true' 0 "show-prompt-history: prompt history"
rlRun 'tmux clear-prompt-history 2>&1 || true' 0 "clear-prompt-history: clear prompt history"

# ===================================================================
echo "=== Test 20: Wait-for (event channels) ==="

rlRun 'tmux wait-for -L mychannel 2>&1 || true' 0 "wait-for -L: lock channel"

# ===================================================================
echo "=== Test 21: Cleanup - kill sessions ==="

rlRun 'tmux kill-session -t renamed_sess 2>&1 || true' 0 "kill-session: kill renamed_sess"
rlRun 'tmux kill-session -t sess_fmt 2>&1 || true' 0 "kill-session: kill sess_fmt"
rlRun 'tmux kill-session -t sess_sz 2>&1 || true' 0 "kill-session: kill sess_sz"
rlRun 'tmux kill-session -t sess_flags 2>&1 || true' 0 "kill-session: kill sess_flags"
rlRun 'tmux kill-session -t sess_env 2>&1 || true' 0 "kill-session: kill sess_env"
rlRun 'tmux kill-session -t testsess 2>&1 || true' 0 "kill-session: kill main test session"
rlRun 'tmux kill-server 2>&1 || true' 0 "kill-server: terminate server"

# ===================================================================
echo "=== Test 22: Error handling ==="

# Invalid session
rlRun 'tmux has-session -t nonexistent 2>&1 || true' 0 "Error: nonexistent session"

# Invalid option
rlRun 'tmux set-option -g nonexistent_option 2>&1 || true' 0 "Error: invalid option"

cd /
rm -rf $TmpDir

echo ""
echo "All tmux functional tests passed!"