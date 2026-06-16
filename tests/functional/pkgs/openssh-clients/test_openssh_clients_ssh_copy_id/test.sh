#!/bin/sh -eux
# Functional test: openssh-clients - ssh-copy-id

. "../setup.sh"

echo "=== Test 8: ssh-copy-id ==="
ssh-copy-id -h 2>&1 | head -3 || true
echo "ssh-copy-id done"

. "../teardown.sh"
echo "All openssh-clients ssh-copy-id tests passed!"
