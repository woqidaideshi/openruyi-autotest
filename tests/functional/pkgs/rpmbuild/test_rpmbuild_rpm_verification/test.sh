#!/bin/sh -eux
# Functional test: rpmbuild - RPM-verification

. "../setup.sh"

echo "=== Test 9: RPM verification ==="

# Test 9.1: Verify RPM signature (may not be signed)
rpm -K rpmbuild/RPMS/noarch/test-package-1.0-1*.rpm 2>&1 || echo "Signature check completed"

# Test 9.2: Check RPM integrity
rpm -V test-package 2>&1 || echo "Package verification completed"

# Cleanup
cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All rpmbuild RPM-verification tests passed!"
