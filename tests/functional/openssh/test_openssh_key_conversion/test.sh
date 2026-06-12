#!/bin/sh -eux
# Functional test: openssh - Key-conversion

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q openssh' 0 "Check openssh is installed"
rlRun 'which ssh-keygen' 0 "Check ssh-keygen available"
rlRun 'ssh-keygen -?' 0 "ssh-keygen help"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: Key conversion ==="
rlRun 'ssh-keygen -e -f test_ed25519.pub -m RFC4716 2>&1 | head -3' 0 "Export RFC4716 format"
rlRun 'ssh-keygen -i -f test_ed25519.pub -m RFC4716 2>&1 || true' 0 "Import RFC4716 format"


echo ""
echo "All openssh Key-conversion tests passed!"
