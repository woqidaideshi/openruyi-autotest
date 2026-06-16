#!/bin/sh -eux
# Functional test: rpmbuild - Verify-built-RPM

. "../setup.sh"

echo "=== Test 5: Verify built RPM ==="

# Test 5.1: Query RPM info
rpm -qpil rpmbuild/RPMS/noarch/test-package-1.0-1*.rpm | head -20

# Test 5.2: Verify RPM dependencies
rpm -qpR rpmbuild/RPMS/noarch/test-package-1.0-1*.rpm

# Test 5.3: Check RPM provides
rpm -qp --provides rpmbuild/RPMS/noarch/test-package-1.0-1*.rpm

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All rpmbuild Verify-built-RPM tests passed!"
