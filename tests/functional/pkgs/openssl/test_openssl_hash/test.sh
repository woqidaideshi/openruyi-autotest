#!/bin/sh -eux
# Functional test: openssl - ��ϣ����
# Commands: openssl

. "../setup.sh"

rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱĿ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"

echo "=== openssl ��ϣ ==="
rlRun 'echo "test data" > testfile' 0 "���������ļ�"
rlRun 'openssl dgst -md5 testfile' 0 "MD5 ժҪ"
rlRun 'openssl dgst -sha256 testfile' 0 "SHA256 ժҪ"
rlRun 'openssl dgst -sha512 testfile' 0 "SHA512 ժҪ"

. "../teardown.sh"
echo "All openssl-hash functional tests passed!"
