#!/bin/sh -eux
# Functional test: rpmbuild - Create-simple-spec-file

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install rpmbuild ===
INSTALLED_BY_TEST=0
if ! rpm -q rpmbuild 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y rpmbuild 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed rpmbuild"
    else
        echo "SKIP: rpmbuild not available in repos"
        exit 0
    fi
else
    echo "SETUP: rpmbuild already installed"
fi


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


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y rpmbuild 2>/dev/null || true
    echo "TEARDOWN: removed rpmbuild"
fi
echo ""
echo "All rpmbuild Create-simple-spec-file tests passed!"
