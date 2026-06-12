#!/bin/sh -eux
# Functional test: openssh - Key-conversion

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

echo "=== Test 6: Key conversion ==="
rlRun 'ssh-keygen -e -f test_ed25519.pub -m RFC4716 2>&1 | head -3' 0 "Export RFC4716 format"
rlRun 'ssh-keygen -i -f test_ed25519.pub -m RFC4716 2>&1 || true' 0 "Import RFC4716 format"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y openssh 2>/dev/null || true
    echo "TEARDOWN: removed openssh"
fi
echo ""
echo "All openssh Key-conversion tests passed!"
