#!/bin/sh -eux
# Functional test: cmake - CMake-version-and-help

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install cmake ===
INSTALLED_BY_TEST=0
if ! rpm -q cmake 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y cmake 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed cmake"
    else
        echo "SKIP: cmake not available in repos"
        exit 0
    fi
else
    echo "SETUP: cmake already installed"
fi


TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: CMake version and help ==="
cmake --version | grep "cmake version"
cmake --help | head -5
cpack --version 2>&1 || true

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y cmake 2>/dev/null || true
    echo "TEARDOWN: removed cmake"
fi
echo ""
echo "All cmake functional tests passed!"
cd /
rm -rf $TmpDir

echo ""
echo "All cmake CMake-version-and-help tests passed!"
