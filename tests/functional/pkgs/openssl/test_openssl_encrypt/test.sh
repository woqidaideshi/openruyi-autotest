#!/bin/sh -eux
# Functional test: openssl - �ӽ���
# Commands: openssl

. "../setup.sh"

rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱĿ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"

echo "=== openssl �ӽ��� ==="
rlRun 'echo "secret message" > plain.txt' 0 "���������ļ�"
rlRun 'openssl enc -aes-256-cbc -pbkdf2 -in plain.txt -out encrypted.bin -pass pass:test123' 0 "AES����"
rlRun 'test -f encrypted.bin' 0 "��֤�����ļ�����"
rlRun 'openssl enc -aes-256-cbc -d -pbkdf2 -in encrypted.bin -out decrypted.txt -pass pass:test123' 0 "AES����"
rlRun 'diff plain.txt decrypted.txt' 0 "��֤���ܽ��һ��"

. "../teardown.sh"
echo "All openssl-encrypt functional tests passed!"
