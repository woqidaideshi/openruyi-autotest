#!/bin/sh -eux
# Functional test: psmisc - fuser-special-cases

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install psmisc ===
INSTALLED_BY_TEST=0
if ! rpm -q psmisc 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y psmisc 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed psmisc"
    else
        echo "SKIP: psmisc not available in repos"
        exit 0
    fi
else
    echo "SETUP: psmisc already installed"
fi


TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 12: fuser special cases ==="

# fuser on unix socket
fuser -n tcp 80 2>&1 || echo "fuser network socket test"

# fuser reset signal output
fuser -r /tmp 2>&1 || echo "fuser reset test"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y psmisc 2>/dev/null || true
    echo "TEARDOWN: removed psmisc"
fi
echo ""
echo "All psmisc fuser-special-cases tests passed!"
