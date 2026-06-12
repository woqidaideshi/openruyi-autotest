#!/bin/sh -eux
# Functional test: rpmbuild - rpmbuild-basic-functionality

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: rpmbuild basic functionality ==="

# Test 1.1: Check rpmbuild version
rpmbuild --version

# Test 1.2: Setup RPM build tree
TmpDir=$(mktemp -d)
cd $TmpDir
rpmdev-setuptree
ls -la rpmbuild/
ls -la rpmbuild/SOURCES rpmbuild/SPECS rpmbuild/BUILD rpmbuild/RPMS rpmbuild/SRPMS

cd /
rm -rf $TmpDir

echo ""
echo "All rpmbuild rpmbuild-basic-functionality tests passed!"
