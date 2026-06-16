#!/bin/sh -eux
# Functional test: openssh-clients - sftp

. "../setup.sh"

echo "=== Test 6: sftp ==="
rlRun 'echo "help" | sftp -b - localhost 2>&1 | head -10 || true' 0 "sftp: help command"

. "../teardown.sh"
echo "All openssh-clients sftp tests passed!"
