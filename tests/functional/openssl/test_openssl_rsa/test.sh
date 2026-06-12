#!/bin/sh -eux
# Functional test: openssl - RSA
# Commands: openssl

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q openssl 2>/dev/null || { echo 'openssl not installed, skipping'; exit 0; }
which openssl 2>/dev/null || echo 'openssl not found'
rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱĿ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"

echo "=== openssl RSA ==="
rlRun 'openssl genrsa -out key.pem 2048' 0 "����RSA˽Կ"
rlRun 'test -f key.pem' 0 "��֤˽Կ�ļ�����"
rlRun 'openssl rsa -in key.pem -pubout -out pub.pem' 0 "��ȡ��Կ"
rlRun 'test -f pub.pem' 0 "��֤��Կ�ļ�����"

echo ""
echo "All openssl-rsa functional tests passed!"
