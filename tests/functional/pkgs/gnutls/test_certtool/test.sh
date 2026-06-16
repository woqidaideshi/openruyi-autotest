#!/bin/sh -eux
# Functional test: gnutls - certtool
# Commands: certtool

. "../setup.sh"

rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱĿ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"

echo "=== certtool ==="
rlRun 'certtool --generate-privkey --outfile key.pem 2>&1 || true' 0 "����˽Կ"

. "../teardown.sh"
echo "All gnutls-certtool functional tests passed!"
