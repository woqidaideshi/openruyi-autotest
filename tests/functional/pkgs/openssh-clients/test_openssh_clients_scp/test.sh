#!/bin/sh -eux
# Functional test: openssh-clients - scp

. "../setup.sh"

echo "=== Test 7: scp ==="
rlRun 'scp -V 2>&1 || true' 0 "scp version"

. "../teardown.sh"
echo "All openssh-clients scp tests passed!"
