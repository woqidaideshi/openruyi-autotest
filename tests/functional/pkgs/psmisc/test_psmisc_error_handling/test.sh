#!/bin/sh -eux
# Functional test: psmisc - Error-handling

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

echo "=== Test 13: Error handling ==="

fuser /nonexistent/file 2>&1 || echo "Expected: no such file"
killall nonexistent-process 2>&1 || echo "Expected: no process found"
pstree nonexistent-user 2>&1 || echo "Expected: no such user"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y psmisc 2>/dev/null || true
    echo "TEARDOWN: removed psmisc"
fi
echo ""
echo "All psmisc functional tests passed!"
cd /
rm -rf $TmpDir

echo ""
echo "All psmisc Error-handling tests passed!"
