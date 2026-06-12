#!/bin/sh -eux
# Functional test: rpmbuild - Create-simple-spec-file

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

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

cd /
rm -rf $TmpDir

echo ""
echo "All rpmbuild Create-simple-spec-file tests passed!"
