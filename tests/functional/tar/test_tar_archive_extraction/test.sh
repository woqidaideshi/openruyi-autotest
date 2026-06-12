#!/bin/sh -eux
# Functional test: tar - Archive-extraction

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

echo "=== Test 2: Archive extraction ==="

# Test 2.1: Extract archive
mkdir extract_dir
cd extract_dir
tar -xvf ../archive.tar
ls -la
cd ..

# Test 2.2: Verify extracted files
cat extract_dir/file1.txt
cat extract_dir/file2.txt

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tar 2>/dev/null || true
    echo "TEARDOWN: removed tar"
fi
echo ""
echo "All tar Archive-extraction tests passed!"
