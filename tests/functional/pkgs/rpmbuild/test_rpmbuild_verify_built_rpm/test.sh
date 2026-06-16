#!/bin/sh -eux
# Functional test: rpmbuild - Verify-built-RPM

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

echo "=== Test 5: Verify built RPM ==="

# Test 5.1: Query RPM info
rpm -qpil rpmbuild/RPMS/noarch/test-package-1.0-1*.rpm | head -20

# Test 5.2: Verify RPM dependencies
rpm -qpR rpmbuild/RPMS/noarch/test-package-1.0-1*.rpm

# Test 5.3: Check RPM provides
rpm -qp --provides rpmbuild/RPMS/noarch/test-package-1.0-1*.rpm

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y rpmbuild 2>/dev/null || true
    echo "TEARDOWN: removed rpmbuild"
fi
echo ""
echo "All rpmbuild Verify-built-RPM tests passed!"
