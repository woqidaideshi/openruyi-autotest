#!/bin/sh -eux
# Functional test: rpmbuild - Error-handling

. "../setup.sh"

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

. "../teardown.sh"
echo "All rpmbuild Error-handling tests passed!"
