#!/bin/sh -eux
# Functional test: openssl - �ӽ���
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

echo "=== openssl �ӽ��� ==="
rlRun 'echo "secret message" > plain.txt' 0 "���������ļ�"
rlRun 'openssl enc -aes-256-cbc -pbkdf2 -in plain.txt -out encrypted.bin -pass pass:test123' 0 "AES����"
rlRun 'test -f encrypted.bin' 0 "��֤�����ļ�����"
rlRun 'openssl enc -aes-256-cbc -d -pbkdf2 -in encrypted.bin -out decrypted.txt -pass pass:test123' 0 "AES����"
rlRun 'diff plain.txt decrypted.txt' 0 "��֤���ܽ��һ��"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y openssl 2>/dev/null || true
    echo "TEARDOWN: removed openssl"
fi
echo ""
echo "All openssl-encrypt functional tests passed!"
