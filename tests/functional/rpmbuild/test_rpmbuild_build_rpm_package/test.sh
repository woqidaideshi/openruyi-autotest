#!/bin/sh -eux
# Functional test: rpmbuild - Build-RPM-package

rlRun() { eval "$1" 2>&1; return $?; }

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

echo ""
echo "All rpmbuild Build-RPM-package tests passed!"
