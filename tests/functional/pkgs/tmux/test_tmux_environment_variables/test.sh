#!/bin/sh -eux
# Functional test: tmux - Environment-variables

. "../setup.sh"

echo "=== Test 9: Environment variables ==="

# 9.1 set-environment
rlRun 'tmux set-environment -g MY_VAR test_value' 0 "set-environment -g: global env"
rlRun 'tmux set-environment -t testsess SESSION_VAR session_val' 0 "set-environment: session env"
rlRun 'tmux set-environment -gru MY_VAR' 0 "set-environment -gur: update then remove"

# 9.2 show-environment
rlRun 'tmux show-environment -g | head -10' 0 "show-environment -g: global env"
rlRun 'tmux show-environment -t testsess | head -10' 0 "show-environment: session env"

# ===================================================================

. "../teardown.sh"
echo "All tmux Environment-variables tests passed!"
