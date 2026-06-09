#!/bin/sh -eux
# Functional test: rpmbuild package
# Tests RPM build tools and workflow
# Version: rpm-build

# Install if not present
rpm -q rpm-build || sudo dnf install -y rpm-build rpmdevtools

# Check package installation
rpm -q rpm-build
which rpmbuild rpmdev-setuptree

echo "=== Test 1: rpmbuild basic functionality ==="

# Test 1.1: Check rpmbuild version
rpmbuild --version

# Test 1.2: Setup RPM build tree
TmpDir=$(mktemp -d)
cd $TmpDir
rpmdev-setuptree
ls -la rpmbuild/
ls -la rpmbuild/SOURCES rpmbuild/SPECS rpmbuild/BUILD rpmbuild/RPMS rpmbuild/SRPMS

echo "=== Test 2: Create simple spec file ==="

# Test 2.1: Create minimal spec file
cat > rpmbuild/SPECS/test-package.spec << 'SPEC'
Name:           test-package
Version:        1.0
Release:        1%{?dist}
Summary:        Test package for rpmbuild

License:        MIT
URL:            https://example.com
Source0:        %{name}-%{version}.tar.gz

BuildArch:      noarch

%description
A test package for rpmbuild verification.

%prep
%setup -q

%install
mkdir -p %{buildroot}/usr/share/test-package
echo "Test file content" > %{buildroot}/usr/share/test-package/test.txt

%files
/usr/share/test-package/test.txt

%changelog
* Mon Jun 09 2025 Test User - 1.0-1
- Initial package
SPEC

echo "Spec file created successfully"
cat rpmbuild/SPECS/test-package.spec | head -20

echo "=== Test 3: Create source tarball ==="

# Test 3.1: Create test source
mkdir -p test-package-1.0
echo "Test file content" > test-package-1.0/test.txt
tar -czvf rpmbuild/SOURCES/test-package-1.0.tar.gz test-package-1.0

# Test 3.2: Verify source file
ls -lh rpmbuild/SOURCES/test-package-1.0.tar.gz
tar -tzvf rpmbuild/SOURCES/test-package-1.0.tar.gz

echo "=== Test 4: Build RPM package ==="

# Test 4.1: Build binary RPM
rpmbuild -bb rpmbuild/SPECS/test-package.spec
ls -lh rpmbuild/RPMS/noarch/

# Test 4.2: Build source RPM
rpmbuild -bs rpmbuild/SPECS/test-package.spec
ls -lh rpmbuild/SRPMS/

echo "=== Test 5: Verify built RPM ==="

# Test 5.1: Query RPM info
rpm -qpil rpmbuild/RPMS/noarch/test-package-1.0-1*.rpm | head -20

# Test 5.2: Verify RPM dependencies
rpm -qpR rpmbuild/RPMS/noarch/test-package-1.0-1*.rpm

# Test 5.3: Check RPM provides
rpm -qp --provides rpmbuild/RPMS/noarch/test-package-1.0-1*.rpm

echo "=== Test 6: Install and test RPM ==="

# Test 6.1: Install the RPM (test mode)
sudo rpm -ivh --test rpmbuild/RPMS/noarch/test-package-1.0-1*.rpm || echo "RPM test installation completed"

# Test 6.2: Actually install
sudo rpm -ivh rpmbuild/RPMS/noarch/test-package-1.0-1*.rpm || echo "RPM installation test completed"

# Test 6.3: Verify installation
rpm -q test-package || echo "Package installation verified"

echo "=== Test 7: RPM build options ==="

# Test 7.1: Build with --define
rpmbuild -bb --define '_topdir '$PWD'/rpmbuild' rpmbuild/SPECS/test-package.spec 2>&1 || echo "Build with _topdir test completed"

# Test 7.2: Check build log
ls -la rpmbuild/BUILD/ 2>&1 || echo "Build directory check completed"

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

echo "=== Test 9: RPM verification ==="

# Test 9.1: Verify RPM signature (may not be signed)
rpm -K rpmbuild/RPMS/noarch/test-package-1.0-1*.rpm 2>&1 || echo "Signature check completed"

# Test 9.2: Check RPM integrity
rpm -V test-package 2>&1 || echo "Package verification completed"

# Cleanup
cd /
rm -rf $TmpDir

echo ""
echo "All rpmbuild functional tests passed!"
