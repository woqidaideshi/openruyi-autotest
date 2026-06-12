#!/bin/sh -eux
# Functional test: openssl - ��ϣ����
# Commands: openssl

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q openssl 2>/dev/null || { echo 'openssl not installed, skipping'; exit 0; }
which openssl 2>/dev/null || echo 'openssl not found'
rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱĿ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"

echo "=== openssl ��ϣ ==="
rlRun 'echo "test data" > testfile' 0 "���������ļ�"
rlRun 'openssl dgst -md5 testfile' 0 "MD5 ժҪ"
rlRun 'openssl dgst -sha256 testfile' 0 "SHA256 ժҪ"
rlRun 'openssl dgst -sha512 testfile' 0 "SHA512 ժҪ"

echo ""
echo "All openssl-hash functional tests passed!"
