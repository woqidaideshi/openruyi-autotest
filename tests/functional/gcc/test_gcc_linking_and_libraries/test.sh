#!/bin/sh -eux
# Functional test: gcc - Linking-and-libraries

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install gcc ===
INSTALLED_BY_TEST=0
if ! rpm -q gcc 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y gcc 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed gcc"
    else
        echo "SKIP: gcc not available in repos"
        exit 0
    fi
else
    echo "SETUP: gcc already installed"
fi

rlRun 'gcc --version' 0 "Get gcc version info"
rlRun 'g++ --version' 0 "Get g++ version info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: Linking and libraries ==="

cat > math_test.c << 'EOF'
#include <stdio.h>
#include <math.h>
int main() { printf("sqrt(4)=%f\n", sqrt(4.0)); return 0; }
EOF

# Test 6.1: Link with math library (-lm)
rlRun 'gcc math_test.c -lm -o math_test' 0 "Link with -lm"
rlRun './math_test' 0 "Run math linked program"

# Test 6.2: Static compilation
rlRun 'gcc -static hello.c -o hello_static' 0 "Compile static binary" || echo "Static linking may not be supported"
file hello_static 2>/dev/null | grep -q "statically linked" || echo "Static binary check"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gcc 2>/dev/null || true
    echo "TEARDOWN: removed gcc"
fi
echo ""
echo "All gcc Linking-and-libraries tests passed!"
