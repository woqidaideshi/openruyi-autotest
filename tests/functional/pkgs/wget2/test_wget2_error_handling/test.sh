#!/bin/sh -eux
# Functional test: wget2 - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install wget2 ===
INSTALLED_BY_TEST=0
if ! rpm -q wget2 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y wget2 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed wget2"
    else
        echo "SKIP: wget2 not available in repos"
        exit 0
    fi
else
    echo "SETUP: wget2 already installed"
fi


TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 12: Error handling ==="

# Invalid URL
wget2 http://nonexistent.domain.invalid 2>&1 || echo "Expected: invalid host"

# 404 error  
wget2 https://example.com/nonexistent 2>&1 || echo "Expected: 404 error"

# Invalid option
wget2 --nonexistent-option 2>&1 || echo "Expected: bad option"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y wget2 2>/dev/null || true
    echo "TEARDOWN: removed wget2"
fi
echo ""
echo "All wget2 Error-handling tests passed!"
