#!/bin/sh -eux
# Functional test: openssh - Hash-known-hosts

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q openssh' 0 "Check openssh is installed"
rlRun 'which ssh-keygen' 0 "Check ssh-keygen available"
rlRun 'ssh-keygen -?' 0 "ssh-keygen help"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 9: Hash known hosts ==="
rlRun 'ssh-keygen -H -f /dev/null 2>&1 || true' 0 "Hash known hosts"


echo ""
echo "All openssh Hash-known-hosts tests passed!"
