#!/bin/sh -eux
# Functional test: openssl - �ӽ���
# Commands: openssl

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q openssl 2>/dev/null || { echo 'openssl not installed, skipping'; exit 0; }
which openssl 2>/dev/null || echo 'openssl not found'
rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱĿ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"

echo "=== openssl �ӽ��� ==="
rlRun 'echo "secret message" > plain.txt' 0 "���������ļ�"
rlRun 'openssl enc -aes-256-cbc -pbkdf2 -in plain.txt -out encrypted.bin -pass pass:test123' 0 "AES����"
rlRun 'test -f encrypted.bin' 0 "��֤�����ļ�����"
rlRun 'openssl enc -aes-256-cbc -d -pbkdf2 -in encrypted.bin -out decrypted.txt -pass pass:test123' 0 "AES����"
rlRun 'diff plain.txt decrypted.txt' 0 "��֤���ܽ��һ��"

echo ""
echo "All openssl-encrypt functional tests passed!"
