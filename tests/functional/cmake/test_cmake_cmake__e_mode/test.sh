#!/bin/sh -eux
# Functional test: cmake - CMake--E-mode

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

echo "=== Test 3: CMake -E mode ==="
cmake -E echo "test"
cmake -E environment 2>&1 | head -5
cmake -E make_directory test_dir && test -d test_dir

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y cmake 2>/dev/null || true
    echo "TEARDOWN: removed cmake"
fi
echo ""
echo "All cmake CMake--E-mode tests passed!"
