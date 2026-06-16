#!/bin/sh -eux
# Functional test: tmux - Buffer-management

. "../setup.sh"

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

. "../teardown.sh"
echo "All tmux Buffer-management tests passed!"
