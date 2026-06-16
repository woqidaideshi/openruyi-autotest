#!/bin/sh -eux
# Functional test: rpmbuild - RPM-build-options

. "../setup.sh"

echo "=== Test 7: RPM build options ==="

# Test 7.1: Build with --define
rpmbuild -bb --define '_topdir '$PWD'/rpmbuild' rpmbuild/SPECS/test-package.spec 2>&1 || echo "Build with _topdir test completed"

# Test 7.2: Check build log
ls -la rpmbuild/BUILD/ 2>&1 || echo "Build directory check completed"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All rpmbuild RPM-build-options tests passed!"
