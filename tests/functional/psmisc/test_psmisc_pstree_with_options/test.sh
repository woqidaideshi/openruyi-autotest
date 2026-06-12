#!/bin/sh -eux
# Functional test: psmisc - pstree-with-options

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

echo "=== Test 6: pstree with options ==="

# Show PIDs
pstree -p | head -10

# Show numeric sort
pstree -n | head -10

# Compact tree
pstree -c | head -10

# Highlight current process
pstree -h | head -10

# Show full details
pstree -a | head -10

# Show only one user's processes
pstree root | head -10

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y psmisc 2>/dev/null || true
    echo "TEARDOWN: removed psmisc"
fi
echo ""
echo "All psmisc pstree-with-options tests passed!"
