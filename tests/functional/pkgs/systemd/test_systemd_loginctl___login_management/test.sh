#!/bin/sh -eux
# Functional test: systemd - loginctl---Login-management

. "../setup.sh"

echo "=== Test 7: loginctl - Login management ==="

rlRun 'loginctl --version 2>&1 || true' 0 "loginctl version"
rlRun 'loginctl list-sessions' 0 "loginctl list-sessions"
rlRun 'loginctl list-users' 0 "loginctl list-users"
rlRun 'loginctl show-session 2>&1 | head -10' 0 "loginctl show-session"
rlRun 'loginctl show-user openruyi 2>&1 | head -10' 0 "loginctl show-user"
rlRun 'loginctl user-status openruyi 2>&1 | head -10' 0 "loginctl user-status"

# ===================================================================

. "../teardown.sh"
echo "All systemd loginctl---Login-management tests passed!"
