#!/bin/sh -eux
# Functional test: openssh - RSA-key-generation

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install openssh ===
INSTALLED_BY_TEST=0
if ! rpm -q openssh 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y openssh 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed openssh"
    else
        echo "SKIP: openssh not available in repos"
        exit 0
    fi
else
    echo "SETUP: openssh already installed"
fi

rlRun 'ssh-keygen -?' 0 "ssh-keygen help"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: RSA key generation ==="
rlRun 'ssh-keygen -t rsa -b 2048 -f test_rsa -N "" -q' 0 "Generate RSA 2048 key"
rlRun 'test -f test_rsa' 0 "Private key exists"
rlRun 'test -f test_rsa.pub' 0 "Public key exists"
rlRun 'ssh-keygen -l -f test_rsa' 0 "Show RSA key fingerprint"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y openssh 2>/dev/null || true
    echo "TEARDOWN: removed openssh"
fi
echo ""
echo "All openssh RSA-key-generation tests passed!"
