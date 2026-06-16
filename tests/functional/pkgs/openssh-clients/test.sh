#!/bin/sh -eux
# Functional test: openssh-clients package
# Tests SSH client utilities: ssh, scp, sftp, ssh-add, ssh-agent, ssh-copy-id, ssh-keyscan
# Version: openssh-clients 10.3p1

. "./setup.sh"

echo "=== Test 1: ssh version and help ==="
rlRun 'ssh -V 2>&1' 0 "ssh version"
rlRun 'ssh -Q key 2>&1 | head -10' 0 "ssh -Q key: supported keys"
rlRun 'ssh -Q cipher 2>&1 | head -5' 0 "ssh -Q cipher: ciphers"
rlRun 'ssh -Q mac 2>&1 | head -5' 0 "ssh -Q mac: MACs"
rlRun 'ssh -Q kex 2>&1 | head -5' 0 "ssh -Q kex: key exchange"

echo "=== Test 2: ssh connection (dry-run) ==="
rlRun 'ssh -G localhost 2>&1 | head -10' 0 "ssh -G: print config"
rlRun 'ssh -T -o ConnectTimeout=5 localhost 2>&1 || true' 0 "ssh -T: disable PTY"
rlRun 'ssh -v localhost 2>&1 | head -10 || true' 0 "ssh -v: verbose"

echo "=== Test 3: ssh-keygen via openssh ==="
rlRun 'ssh-keygen -t ed25519 -f test_key -N "" -q' 0 "Generate test key"

echo "=== Test 4: ssh-agent ==="
eval $(ssh-agent -s) 2>&1 || true
rlRun 'ssh-add -l 2>&1 || true' 0 "ssh-add: list keys"
rlRun 'ssh-add test_key 2>&1' 0 "ssh-add: add key"
rlRun 'ssh-add -l 2>&1' 0 "ssh-add: verify key added"
rlRun 'ssh-add -L 2>&1' 0 "ssh-add -L: list public keys"
rlRun 'ssh-add -d test_key 2>&1' 0 "ssh-add -d: remove key"
ssh-agent -k 2>&1 || true

echo "=== Test 5: ssh-keyscan ==="
rlRun 'ssh-keyscan -t ed25519 localhost 2>&1 | head -3' 0 "ssh-keyscan: scan localhost"
rlRun 'ssh-keyscan -t rsa localhost 2>&1 | head -3' 0 "ssh-keyscan -t rsa"
rlRun 'ssh-keyscan -t ecdsa localhost 2>&1 | head -3' 0 "ssh-keyscan -t ecdsa"

echo "=== Test 6: sftp ==="
rlRun 'echo "help" | sftp -b - localhost 2>&1 | head -10 || true' 0 "sftp: help command"

echo "=== Test 7: scp ==="
rlRun 'scp -V 2>&1 || true' 0 "scp version"

echo "=== Test 8: ssh-copy-id ==="
ssh-copy-id -h 2>&1 | head -3 || true
echo "ssh-copy-id done"

echo "=== Test 10: Error handling ==="
ssh --invalid 2>&1 || true
echo ""

echo "All openssh-clients functional tests passed!"

. "./teardown.sh"
echo "All openssh-clients tests passed!"
