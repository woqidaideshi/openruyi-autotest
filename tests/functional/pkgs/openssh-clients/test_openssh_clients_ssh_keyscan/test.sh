#!/bin/sh -eux
# Functional test: openssh-clients - ssh-keyscan

. "../setup.sh"

echo "=== Test 5: ssh-keyscan ==="
rlRun 'ssh-keyscan -t ed25519 localhost 2>&1 | head -3' 0 "ssh-keyscan: scan localhost"
rlRun 'ssh-keyscan -t rsa localhost 2>&1 | head -3' 0 "ssh-keyscan -t rsa"
rlRun 'ssh-keyscan -t ecdsa localhost 2>&1 | head -3' 0 "ssh-keyscan -t ecdsa"

. "../teardown.sh"
echo "All openssh-clients ssh-keyscan tests passed!"
