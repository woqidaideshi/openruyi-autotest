#!/bin/sh -eux
# Functional test: rpmbuild - Create-source-tarball

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install rpmbuild ===
INSTALLED_BY_TEST=0
if ! rpm -q rpmbuild 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y rpmbuild 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed rpmbuild"
    else
        echo "SKIP: rpmbuild not available in repos"
        exit 0
    fi
else
    echo "SETUP: rpmbuild already installed"
fi


TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: Create source tarball ==="

# Test 3.1: Create test source
mkdir -p test-package-1.0
echo "Test file content" > test-package-1.0/test.txt
tar -czvf rpmbuild/SOURCES/test-package-1.0.tar.gz test-package-1.0

# Test 3.2: Verify source file
ls -lh rpmbuild/SOURCES/test-package-1.0.tar.gz
tar -tzvf rpmbuild/SOURCES/test-package-1.0.tar.gz

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y rpmbuild 2>/dev/null || true
    echo "TEARDOWN: removed rpmbuild"
fi
echo ""
echo "All rpmbuild Create-source-tarball tests passed!"
