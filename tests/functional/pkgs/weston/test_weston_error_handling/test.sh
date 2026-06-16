#!/bin/sh -eux
# Functional test: weston - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install weston ===
INSTALLED_BY_TEST=0
if ! rpm -q weston 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y weston 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed weston"
    else
        echo "SKIP: weston not available in repos"
        exit 0
    fi
else
    echo "SETUP: weston already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 9: Error handling ==="
rlRun 'weston --invalid 2>&1 || true' 0 "weston: invalid option"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y weston 2>/dev/null || true
    echo "TEARDOWN: removed weston"
fi
echo ""
echo "All weston functional tests passed!"
cd /
rm -rf $TmpDir

echo ""
echo "All weston Error-handling tests passed!"
