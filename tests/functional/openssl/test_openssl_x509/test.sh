#!/bin/sh -eux
# Functional test: openssl - X509֤��
# Commands: openssl

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q openssl 2>/dev/null || { echo 'openssl not installed, skipping'; exit 0; }
which openssl 2>/dev/null || echo 'openssl not found'
rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱĿ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"

echo "=== openssl X509 ==="
rlRun 'openssl genrsa -out ca.key 2048' 0 "����CA˽Կ"
rlRun 'openssl req -new -x509 -key ca.key -out ca.crt -days 1 -subj "/CN=Test"' 0 "������ǩ��֤��"
rlRun 'openssl x509 -in ca.crt -text -noout | head -10' 0 "�鿴֤����Ϣ"

echo ""
echo "All openssl-x509 functional tests passed!"
