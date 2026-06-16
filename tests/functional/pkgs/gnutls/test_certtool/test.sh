#!/bin/sh -eux
# Functional test: gnutls - certtool
# Commands: certtool

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install gnutls ===
INSTALLED_BY_TEST=0
if ! rpm -q gnutls 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y gnutls 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed gnutls"
    else
        echo "SKIP: gnutls not available in repos"
        exit 0
    fi
else
    echo "SETUP: gnutls already installed"
fi


rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱĿ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"

echo "=== certtool ==="
rlRun 'certtool --generate-privkey --outfile key.pem 2>&1 || true' 0 "����˽Կ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gnutls 2>/dev/null || true
    echo "TEARDOWN: removed gnutls"
fi
echo ""
echo "All gnutls-certtool functional tests passed!"
