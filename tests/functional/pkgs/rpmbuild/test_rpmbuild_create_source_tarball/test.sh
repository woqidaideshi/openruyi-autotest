#!/bin/sh -eux
# Functional test: rpmbuild - Create-source-tarball

. "../setup.sh"

echo "=== Test 3: Create source tarball ==="

# Test 3.1: Create test source
mkdir -p test-package-1.0
echo "Test file content" > test-package-1.0/test.txt
tar -czvf rpmbuild/SOURCES/test-package-1.0.tar.gz test-package-1.0

# Test 3.2: Verify source file
ls -lh rpmbuild/SOURCES/test-package-1.0.tar.gz
tar -tzvf rpmbuild/SOURCES/test-package-1.0.tar.gz

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All rpmbuild Create-source-tarball tests passed!"
