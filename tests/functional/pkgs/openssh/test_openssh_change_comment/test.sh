#!/bin/sh -eux
# Functional test: openssh - Change-comment

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

echo "=== Test 8: Change comment ==="
rlRun 'ssh-keygen -c -C "new_comment" -f test_comment -P ""' 0 "Change key comment"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y openssh 2>/dev/null || true
    echo "TEARDOWN: removed openssh"
fi
echo ""
echo "All openssh Change-comment tests passed!"
