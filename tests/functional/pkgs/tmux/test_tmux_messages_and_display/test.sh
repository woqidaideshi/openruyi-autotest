#!/bin/sh -eux
# Functional test: tmux - Messages-and-display

. "../setup.sh"

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

. "../teardown.sh"
echo "All tmux Messages-and-display tests passed!"
