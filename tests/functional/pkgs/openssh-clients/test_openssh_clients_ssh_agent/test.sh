#!/bin/sh -eux
# Functional test: openssh-clients - ssh-agent

. "../setup.sh"

echo "=== Test 4: ssh-agent ==="
eval $(ssh-agent -s) 2>&1 || true
rlRun 'ssh-add -l 2>&1 || true' 0 "ssh-add: list keys"
rlRun 'ssh-add test_key 2>&1' 0 "ssh-add: add key"
rlRun 'ssh-add -l 2>&1' 0 "ssh-add: verify key added"
rlRun 'ssh-add -L 2>&1' 0 "ssh-add -L: list public keys"
rlRun 'ssh-add -d test_key 2>&1' 0 "ssh-add -d: remove key"
ssh-agent -k 2>&1 || true

. "../teardown.sh"
echo "All openssh-clients ssh-agent tests passed!"
