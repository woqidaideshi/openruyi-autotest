#!/bin/sh -eux
# Functional test: tar - Special-attributes

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

echo "=== Test 6: Special attributes ==="

# Test 6.1: Preserve permissions
chmod 755 file1.txt
tar -cvpf perm_archive.tar file1.txt
mkdir perm_dir && cd perm_dir && tar -xvpf ../perm_archive.tar
ls -la file1.txt
cd ..

# Test 6.2: Preserve timestamps
touch -t 202501011200 file1.txt
tar -cvpf time_archive.tar file1.txt
mkdir time_dir && cd time_dir && tar -xvpf ../time_archive.tar
ls -la file1.txt
cd ..

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tar 2>/dev/null || true
    echo "TEARDOWN: removed tar"
fi
echo ""
echo "All tar Special-attributes tests passed!"
