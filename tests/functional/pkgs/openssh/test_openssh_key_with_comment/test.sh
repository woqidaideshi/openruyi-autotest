#!/bin/sh -eux
# Functional test: openssh - Key-with-comment

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

echo "=== Test 5: Key with comment ==="
rlRun 'ssh-keygen -t ed25519 -f test_comment -C "test@example.com" -N "" -q' 0 "Generate key with comment"
rlRun 'grep -q "test@example.com" test_comment.pub' 0 "Verify comment in pubkey"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y openssh 2>/dev/null || true
    echo "TEARDOWN: removed openssh"
fi
echo ""
echo "All openssh Key-with-comment tests passed!"
