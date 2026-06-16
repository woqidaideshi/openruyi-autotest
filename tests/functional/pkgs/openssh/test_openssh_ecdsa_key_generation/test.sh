#!/bin/sh -eux
# Functional test: openssh - ECDSA-key-generation

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

echo "=== Test 2: ECDSA key generation ==="
rlRun 'ssh-keygen -t ecdsa -b 256 -f test_ecdsa -N "" -q' 0 "Generate ECDSA 256 key"
rlRun 'ssh-keygen -l -f test_ecdsa.pub' 0 "Show ECDSA fingerprint"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y openssh 2>/dev/null || true
    echo "TEARDOWN: removed openssh"
fi
echo ""
echo "All openssh ECDSA-key-generation tests passed!"
