#!/bin/sh -eux
# Functional test: openssh-clients - ssh-keygen-via-openssh

. "../setup.sh"

echo "=== Test 3: ssh-keygen via openssh ==="
rlRun 'ssh-keygen -t ed25519 -f test_key -N "" -q' 0 "Generate test key"

. "../teardown.sh"
echo "All openssh-clients ssh-keygen-via-openssh tests passed!"
