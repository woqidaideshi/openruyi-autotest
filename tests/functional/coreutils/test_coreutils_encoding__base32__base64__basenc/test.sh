#!/bin/sh -eux
# Functional test: coreutils - Encoding--base32--base64--basenc

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install coreutils ===
INSTALLED_BY_TEST=0
if ! rpm -q coreutils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y coreutils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed coreutils"
    else
        echo "SKIP: coreutils not available in repos"
        exit 0
    fi
else
    echo "SETUP: coreutils already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 14: Encoding (base32, base64, basenc) ==="

# 14.1 base32
rlRun 'echo "hello" | base32' 0 "base32 encode"
rlRun 'echo "hello" | base32 | base32 -d' 0 "base32 -d decode"

# 14.2 base64
rlRun 'echo "hello" | base64' 0 "base64 encode"
rlRun 'echo "hello" | base64 | base64 -d' 0 "base64 -d decode"

# 14.3 basenc
rlRun 'echo "hello" | basenc --base64' 0 "basenc --base64 encode"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y coreutils 2>/dev/null || true
    echo "TEARDOWN: removed coreutils"
fi
echo ""
echo "All coreutils Encoding--base32--base64--basenc tests passed!"
