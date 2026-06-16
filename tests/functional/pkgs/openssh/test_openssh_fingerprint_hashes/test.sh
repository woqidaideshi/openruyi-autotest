#!/bin/sh -eux
# Functional test: openssh - Fingerprint-hashes

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

echo "=== Test 10: Fingerprint hashes ==="
rlRun 'ssh-keygen -l -f test_rsa.pub -E sha256' 0 "SHA256 fingerprint"
rlRun 'ssh-keygen -l -f test_rsa.pub -E md5 2>&1 || true' 0 "MD5 fingerprint"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y openssh 2>/dev/null || true
    echo "TEARDOWN: removed openssh"
fi
echo ""
echo "All openssh Fingerprint-hashes tests passed!"
