#!/bin/sh -eux
# Functional test: tar - Basic-archive-creation

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

echo "=== Test 1: Basic archive creation ==="

# Test 1.1: Create test files
echo "file1 content" > file1.txt
echo "file2 content" > file2.txt
mkdir testdir
echo "file3 content" > testdir/file3.txt

# Test 1.2: Create tar archive
tar -cvf archive.tar file1.txt file2.txt

# Test 1.3: List archive contents
tar -tvf archive.tar

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tar 2>/dev/null || true
    echo "TEARDOWN: removed tar"
fi
echo ""
echo "All tar Basic-archive-creation tests passed!"
