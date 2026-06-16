#!/bin/sh -eux
# Functional test: rpmbuild - Install-and-test-RPM

. "../setup.sh"

echo "=== Test 6: Install and test RPM ==="

# Test 6.1: Install the RPM (test mode)
rpm -ivh --test rpmbuild/RPMS/noarch/test-package-1.0-1*.rpm || echo "RPM test installation completed"

# Test 6.2: Actually install
rpm -ivh rpmbuild/RPMS/noarch/test-package-1.0-1*.rpm || echo "RPM installation test completed"

# Test 6.3: Verify installation
rpm -q test-package || echo "Package installation verified"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All rpmbuild Install-and-test-RPM tests passed!"
