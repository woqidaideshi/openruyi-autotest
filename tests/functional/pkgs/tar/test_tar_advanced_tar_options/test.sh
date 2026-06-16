#!/bin/sh -eux
# Functional test: tar - Advanced-tar-options

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

echo "=== Test 4: Advanced tar options ==="

# Test 4.1: Append files to existing archive
tar -rvf archive.tar testdir
tar -tvf archive.tar

# Test 4.2: Extract specific files
mkdir extract_specific && cd extract_specific
tar -xvf ../archive.tar file1.txt
ls -la
cd ..

# Test 4.3: Extract to different directory
mkdir -p target_dir
tar -xvf archive.tar -C target_dir
ls -la target_dir

# Test 4.4: Create archive from directory
tar -cvf dir_archive.tar testdir
tar -tvf dir_archive.tar

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tar 2>/dev/null || true
    echo "TEARDOWN: removed tar"
fi
echo ""
echo "All tar Advanced-tar-options tests passed!"
