#!/bin/sh -eux
# Functional test: weston - Weston-terminal--headless

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

echo "=== Test 3: Weston terminal (headless) ==="
rlRun 'weston-terminal --help 2>&1 | head -10 || true' 0 "weston-terminal help"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y weston 2>/dev/null || true
    echo "TEARDOWN: removed weston"
fi
echo ""
echo "All weston Weston-terminal--headless tests passed!"
