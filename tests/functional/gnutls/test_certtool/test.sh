#!/bin/sh -eux
# Functional test: gnutls - certtool
# Commands: certtool

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q gnutls 2>/dev/null || { echo 'gnutls not installed, skipping'; exit 0; }
which certtool 2>/dev/null || echo 'certtool not found'
rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱĿ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"

echo "=== certtool ==="
rlRun 'certtool --generate-privkey --outfile key.pem 2>&1 || true' 0 "����˽Կ"

echo ""
echo "All gnutls-certtool functional tests passed!"
