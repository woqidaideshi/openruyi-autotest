#!/bin/sh -eux
# Functional test: openssl - ��ϣ����
# Commands: openssl

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install openssl ===
INSTALLED_BY_TEST=0
if ! rpm -q openssl 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y openssl 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed openssl"
    else
        echo "SKIP: openssl not available in repos"
        exit 0
    fi
else
    echo "SETUP: openssl already installed"
fi


rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱĿ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"

echo "=== openssl ��ϣ ==="
rlRun 'echo "test data" > testfile' 0 "���������ļ�"
rlRun 'openssl dgst -md5 testfile' 0 "MD5 ժҪ"
rlRun 'openssl dgst -sha256 testfile' 0 "SHA256 ժҪ"
rlRun 'openssl dgst -sha512 testfile' 0 "SHA512 ժҪ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y openssl 2>/dev/null || true
    echo "TEARDOWN: removed openssl"
fi
echo ""
echo "All openssl-hash functional tests passed!"
