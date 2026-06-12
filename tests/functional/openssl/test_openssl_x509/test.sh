#!/bin/sh -eux
# Functional test: openssl - X509֤��
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

echo "=== openssl X509 ==="
rlRun 'openssl genrsa -out ca.key 2048' 0 "����CA˽Կ"
rlRun 'openssl req -new -x509 -key ca.key -out ca.crt -days 1 -subj "/CN=Test"' 0 "������ǩ��֤��"
rlRun 'openssl x509 -in ca.crt -text -noout | head -10' 0 "�鿴֤����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y openssl 2>/dev/null || true
    echo "TEARDOWN: removed openssl"
fi
echo ""
echo "All openssl-x509 functional tests passed!"
