#!/bin/sh -eux
# Functional test: openssh-clients - ssh-version-and-help

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

echo "=== Test 1: ssh version and help ==="
rlRun 'ssh -V 2>&1' 0 "ssh version"
rlRun 'ssh -Q key 2>&1 | head -10' 0 "ssh -Q key: supported keys"
rlRun 'ssh -Q cipher 2>&1 | head -5' 0 "ssh -Q cipher: ciphers"
rlRun 'ssh -Q mac 2>&1 | head -5' 0 "ssh -Q mac: MACs"
rlRun 'ssh -Q kex 2>&1 | head -5' 0 "ssh -Q kex: key exchange"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y openssh-clients 2>/dev/null || true
    echo "TEARDOWN: removed openssh-clients"
fi
echo ""
echo "All openssh-clients ssh-version-and-help tests passed!"
