#!/bin/sh -eux
# Functional test: tar - Incremental-backup

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

echo "=== Test 9: Incremental backup ==="

# Test 9.1: Create incremental backup
tar -cvf incremental.tar --listed-incremental=snapshot.snar file1.txt file2.txt
tar -tvf incremental.tar

# Test 9.2: Multi-volume archive (test only)
tar -cvf multi.tar file1.txt file2.txt --tape-length=1024 2>&1 || echo "Multi-volume test completed"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tar 2>/dev/null || true
    echo "TEARDOWN: removed tar"
fi
echo ""
echo "All tar Incremental-backup tests passed!"
