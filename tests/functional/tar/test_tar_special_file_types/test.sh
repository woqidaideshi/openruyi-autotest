#!/bin/sh -eux
# Functional test: tar - Special-file-types

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

echo "=== Test 10: Special file types ==="

# Test 10.1: Archive with symlinks
ln -s file1.txt link_to_file1
tar -cvhf symlink_archive.tar link_to_file1
tar -tvf symlink_archive.tar

# Test 10.2: Archive with hardlinks
ln file1.txt hardlink_to_file1
tar -cvf hardlink_archive.tar hardlink_to_file1
tar -tvf hardlink_archive.tar

# Cleanup
cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tar 2>/dev/null || true
    echo "TEARDOWN: removed tar"
fi
echo ""
echo "All tar functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All tar Special-file-types tests passed!"
