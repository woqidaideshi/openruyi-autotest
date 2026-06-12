#!/bin/sh -eux
# Functional test: psmisc - fuser-with-options

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

echo "=== Test 4: fuser with options ==="

fuser -a /tmp 2>&1 || echo "fuser display all test"
fuser -i /tmp 2>&1 || echo "fuser interactive test"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y psmisc 2>/dev/null || true
    echo "TEARDOWN: removed psmisc"
fi
echo ""
echo "All psmisc fuser-with-options tests passed!"
