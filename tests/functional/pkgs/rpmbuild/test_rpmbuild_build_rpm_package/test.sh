#!/bin/sh -eux
# Functional test: rpmbuild - Build-RPM-package

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

echo "=== Test 4: Build RPM package ==="

# Test 4.1: Build binary RPM
rpmbuild -bb rpmbuild/SPECS/test-package.spec
ls -lh rpmbuild/RPMS/noarch/

# Test 4.2: Build source RPM
rpmbuild -bs rpmbuild/SPECS/test-package.spec
ls -lh rpmbuild/SRPMS/

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y rpmbuild 2>/dev/null || true
    echo "TEARDOWN: removed rpmbuild"
fi
echo ""
echo "All rpmbuild Build-RPM-package tests passed!"
