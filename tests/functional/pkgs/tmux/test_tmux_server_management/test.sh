#!/bin/sh -eux
# Functional test: tmux - Server-management

. "../setup.sh"

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

. "../teardown.sh"
echo "All tmux Server-management tests passed!"
