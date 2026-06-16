#!/bin/sh -eux
# Functional test: openssl - RSA
# Commands: openssl

. "../setup.sh"

rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱĿ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"

echo "=== openssl RSA ==="
rlRun 'openssl genrsa -out key.pem 2048' 0 "����RSA˽Կ"
rlRun 'test -f key.pem' 0 "��֤˽Կ�ļ�����"
rlRun 'openssl rsa -in key.pem -pubout -out pub.pem' 0 "��ȡ��Կ"
rlRun 'test -f pub.pem' 0 "��֤��Կ�ļ�����"

. "../teardown.sh"
echo "All openssl-rsa functional tests passed!"
