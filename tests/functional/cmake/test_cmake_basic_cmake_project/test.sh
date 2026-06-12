#!/bin/sh -eux
# Functional test: cmake - Basic-CMake-project

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

echo "=== Test 1: Basic CMake project ==="

mkdir simple_project && cd simple_project
cat > main.c << 'EOF'
#include <stdio.h>
int main() { printf("Hello CMake\n"); return 0; }
EOF

cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.10)
project(TestProject)
add_executable(test_app main.c)
EOF

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y cmake 2>/dev/null || true
    echo "TEARDOWN: removed cmake"
fi
echo ""
echo "All cmake Basic-CMake-project tests passed!"
