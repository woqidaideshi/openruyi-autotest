#!/bin/sh -eux
# Functional test: openssh-clients - ssh-agent

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

echo "=== Test 4: ssh-agent ==="
eval $(ssh-agent -s) 2>&1 || true
rlRun 'ssh-add -l 2>&1 || true' 0 "ssh-add: list keys"
rlRun 'ssh-add test_key 2>&1' 0 "ssh-add: add key"
rlRun 'ssh-add -l 2>&1' 0 "ssh-add: verify key added"
rlRun 'ssh-add -L 2>&1' 0 "ssh-add -L: list public keys"
rlRun 'ssh-add -d test_key 2>&1' 0 "ssh-add -d: remove key"
ssh-agent -k 2>&1 || true



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y openssh-clients 2>/dev/null || true
    echo "TEARDOWN: removed openssh-clients"
fi
echo ""
echo "All openssh-clients ssh-agent tests passed!"
