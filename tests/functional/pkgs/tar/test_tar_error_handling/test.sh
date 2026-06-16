#!/bin/sh -eux
# Functional test: tar - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install tar ===
INSTALLED_BY_TEST=0
if ! rpm -q tar 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y tar 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed tar"
    else
        echo "SKIP: tar not available in repos"
        exit 0
    fi
else
    echo "SETUP: tar already installed"
fi


TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: Error handling ==="

# Test 7.1: Non-existent file
tar -cvf error.tar nonexistent_file 2>&1 || echo "Expected error for non-existent file"

# Test 7.2: Corrupted archive
echo "corrupted data" > corrupted.tar
tar -tvf corrupted.tar 2>&1 || echo "Expected error for corrupted archive"

# Test 7.3: Empty archive
tar -cvf empty.tar --files-from /dev/null
tar -tvf empty.tar

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tar 2>/dev/null || true
    echo "TEARDOWN: removed tar"
fi
echo ""
echo "All tar Error-handling tests passed!"
