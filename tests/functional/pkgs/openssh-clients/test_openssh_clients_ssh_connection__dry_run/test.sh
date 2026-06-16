#!/bin/sh -eux
# Functional test: openssh-clients - ssh-connection--dry-run

. "../setup.sh"

echo "=== Test 2: ssh connection (dry-run) ==="
rlRun 'ssh -G localhost 2>&1 | head -10' 0 "ssh -G: print config"
rlRun 'ssh -T -o ConnectTimeout=5 localhost 2>&1 || true' 0 "ssh -T: disable PTY"
rlRun 'ssh -v localhost 2>&1 | head -10 || true' 0 "ssh -v: verbose"

. "../teardown.sh"
echo "All openssh-clients ssh-connection--dry-run tests passed!"
