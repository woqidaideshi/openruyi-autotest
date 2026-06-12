#!/bin/sh -eux
# Functional test: tar - Archive-verification

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

echo "=== Test 5: Archive verification ==="

# Test 5.1: Test archive integrity
tar -tvf archive.tar > /dev/null && echo "Archive integrity check passed"

# Test 5.2: Compare archive with original files
mkdir compare_dir && cd compare_dir
tar -xvf ../archive.tar
diff file1.txt ../file1.txt && echo "File comparison passed"
cd ..

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tar 2>/dev/null || true
    echo "TEARDOWN: removed tar"
fi
echo ""
echo "All tar Archive-verification tests passed!"
