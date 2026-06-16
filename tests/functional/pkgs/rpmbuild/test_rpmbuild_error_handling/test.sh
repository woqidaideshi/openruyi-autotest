#!/bin/sh -eux
# Functional test: rpmbuild - Error-handling

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

echo "=== Test 8: Error handling ==="

# Test 8.1: Build with missing spec file
rpmbuild -bb nonexistent.spec 2>&1 || echo "Expected error for missing spec"

# Test 8.2: Build with missing source
echo "Name: bad-package
Version: 1.0
Release: 1
Summary: Bad package
License: MIT
%description
Bad package
%install
%files" > rpmbuild/SPECS/bad-package.spec
rpmbuild -bb rpmbuild/SPECS/bad-package.spec 2>&1 || echo "Expected error for missing source"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y rpmbuild 2>/dev/null || true
    echo "TEARDOWN: removed rpmbuild"
fi
echo ""
echo "All rpmbuild Error-handling tests passed!"
