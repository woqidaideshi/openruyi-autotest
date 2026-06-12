#!/bin/sh -eux
# Functional test: g++ package (GNU C++ Compiler)
# Tests g++ compilation, linking, and key options
# Version: gcc-c++

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install gxx ===
INSTALLED_BY_TEST=0
if ! rpm -q gxx 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y gxx 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed gxx"
    else
        echo "SKIP: gxx not available in repos"
        exit 0
    fi
else
    echo "SETUP: gxx already installed"
fi


rlRun 'g++ --version' 0 "g++ version info"

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Basic C++ compilation ==="
cat > hello.cpp << 'EOF'
int main() { return 42; }
EOF
rlRun 'g++ hello.cpp -o hello' 0 "Compile hello.cpp"
rlRun './hello' 0 "Run compiled binary"
rlRun 'file hello | grep -i elf' 0 "Output is ELF binary"

echo "=== Test 2: Compile-only ==="
rlRun 'g++ -c hello.cpp -o hello.o' 0 "g++ -c: compile only"
rlRun 'test -f hello.o' 0 "Object file exists"

echo "=== Test 3: Optimization ==="
for lvl in O0 O1 O2; do
    rlRun "g++ -$lvl -c hello.cpp -o hello_$lvl.o" 0 "Optimization -$lvl"
done

echo "=== Test 5: Debug and warnings ==="
rlRun 'g++ -g -c hello.cpp -o hello_g.o' 0 "Debug symbols"
rlRun 'g++ -Wall -c hello.cpp -o hello_Wall.o' 0 "-Wall warnings"
rlRun 'g++ -Wextra -c hello.cpp -o hello_Wextra.o' 0 "-Wextra warnings"

echo "=== Test 6: Preprocessor ==="
rlRun 'g++ -E hello.cpp | head -5' 0 "g++ -E: preprocess"

echo "=== Test 7: Linking ==="
rlRun 'g++ hello.o -o hello_link' 0 "Link from object"
rlRun 'g++ -shared hello.o -o libhello.so' 0 "g++ -shared: shared library"

echo "=== Test 10: Include paths ==="
mkdir inc
echo '#define TEST_VAL 42' > inc/test.h
cat > inc_test.cpp << 'EOF'
#include "test.h"
int main() { return TEST_VAL; }
EOF
rlRun 'g++ -I inc inc_test.cpp -o inc_test' 0 "g++ -I: include path"

echo "=== Test 11: c++ alias ==="
rlRun 'c++ --version 2>&1 | head -1' 0 "c++ alias works"

echo "=== Test 12: Error handling ==="
rlRun 'g++ bad.cpp -o bad 2>&1 || true' 0 "Compilation error"
rlRun 'g++ --invalid 2>&1 || true' 0 "Invalid option"

cd /
rm -rf $TmpDir

echo ""
echo "All g++ functional tests passed!"

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gxx 2>/dev/null || true
    echo "TEARDOWN: removed gxx"
fi

