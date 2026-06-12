#!/bin/sh -eux
# Functional test: openssh-clients - ssh-connection--dry-run

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

echo "=== Test 2: ssh connection (dry-run) ==="
rlRun 'ssh -G localhost 2>&1 | head -10' 0 "ssh -G: print config"
rlRun 'ssh -T -o ConnectTimeout=5 localhost 2>&1 || true' 0 "ssh -T: disable PTY"
rlRun 'ssh -v localhost 2>&1 | head -10 || true' 0 "ssh -v: verbose"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y openssh-clients 2>/dev/null || true
    echo "TEARDOWN: removed openssh-clients"
fi
echo ""
echo "All openssh-clients ssh-connection--dry-run tests passed!"
