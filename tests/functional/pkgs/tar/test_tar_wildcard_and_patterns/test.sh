#!/bin/sh -eux
# Functional test: tar - Wildcard-and-patterns

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

echo "=== Test 8: Wildcard and patterns ==="

# Test 8.1: Extract with wildcard pattern
mkdir pattern_dir && cd pattern_dir
tar -xvf ../archive.tar --wildcards '*.txt'
ls -la
cd ..

# Test 8.2: Exclude patterns
tar -cvf exclude_archive.tar --exclude='*.txt' file1.txt file2.txt testdir
tar -tvf exclude_archive.tar

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tar 2>/dev/null || true
    echo "TEARDOWN: removed tar"
fi
echo ""
echo "All tar Wildcard-and-patterns tests passed!"
