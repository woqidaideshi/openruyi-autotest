#!/bin/sh -eux
# Functional test: rpmbuild - rpmbuild-basic-functionality

. "../setup.sh"

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

. "../teardown.sh"
echo "All rpmbuild rpmbuild-basic-functionality tests passed!"
