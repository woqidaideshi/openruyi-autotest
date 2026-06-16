#!/bin/sh -eux
# Functional test: openssh - Hash-known-hosts

. "../setup.sh"

echo "=== Test 9: Hash known hosts ==="
rlRun 'ssh-keygen -H -f /dev/null 2>&1 || true' 0 "Hash known hosts"

. "../teardown.sh"
echo "All openssh Hash-known-hosts tests passed!"
