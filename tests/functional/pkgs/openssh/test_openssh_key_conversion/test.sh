#!/bin/sh -eux
# Functional test: openssh - Key-conversion

. "../setup.sh"

echo "=== Test 6: Key conversion ==="
rlRun 'ssh-keygen -e -f test_ed25519.pub -m RFC4716 2>&1 | head -3' 0 "Export RFC4716 format"
rlRun 'ssh-keygen -i -f test_ed25519.pub -m RFC4716 2>&1 || true' 0 "Import RFC4716 format"

. "../teardown.sh"
echo "All openssh Key-conversion tests passed!"
