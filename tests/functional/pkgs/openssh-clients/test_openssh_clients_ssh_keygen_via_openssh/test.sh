#!/bin/sh -eux
# Functional test: openssh-clients - ssh-keygen-via-openssh

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install openssh-clients ===
INSTALLED_BY_TEST=0
if ! rpm -q openssh-clients 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y openssh-clients 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed openssh-clients"
    else
        echo "SKIP: openssh-clients not available in repos"
        exit 0
    fi
else
    echo "SETUP: openssh-clients already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: ssh-keygen via openssh ==="
rlRun 'ssh-keygen -t ed25519 -f test_key -N "" -q' 0 "Generate test key"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y openssh-clients 2>/dev/null || true
    echo "TEARDOWN: removed openssh-clients"
fi
echo ""
echo "All openssh-clients ssh-keygen-via-openssh tests passed!"
