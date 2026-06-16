#!/bin/sh -eux
# Functional test: openssh-clients - ssh-version-and-help

. "../setup.sh"

echo "=== Test 1: ssh version and help ==="
rlRun 'ssh -V 2>&1' 0 "ssh version"
rlRun 'ssh -Q key 2>&1 | head -10' 0 "ssh -Q key: supported keys"
rlRun 'ssh -Q cipher 2>&1 | head -5' 0 "ssh -Q cipher: ciphers"
rlRun 'ssh -Q mac 2>&1 | head -5' 0 "ssh -Q mac: MACs"
rlRun 'ssh -Q kex 2>&1 | head -5' 0 "ssh -Q kex: key exchange"

. "../teardown.sh"
echo "All openssh-clients ssh-version-and-help tests passed!"
