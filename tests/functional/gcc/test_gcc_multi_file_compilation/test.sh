#!/bin/sh -eux
# Functional test: gcc - Multi-file-compilation

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

echo "=== Test 8: Multi-file compilation ==="

# Test 8.1: Separate compilation and linking
cat > add.c << 'EOF'
int add(int a, int b) { return a + b; }
EOF
cat > add.h << 'EOF'
int add(int a, int b);
EOF
cat > main.c << 'EOF'
#include <stdio.h>
#include "add.h"
int main() { printf("1+2=%d\n", add(1,2)); return 0; }
EOF

rlRun 'gcc -c add.c -o add.o' 0 "Compile add.c to object"
rlRun 'gcc -c main.c -o main.o' 0 "Compile main.c to object"
rlRun 'gcc add.o main.o -o multi_bin' 0 "Link multiple objects"
rlRun './multi_bin' 0 "Run multi-file program"

# Test 8.2: Single command multi-file compile
rlRun 'gcc add.c main.c -o multi_bin2' 0 "Compile multiple files in one command"
rlRun './multi_bin2' 0 "Run single-command multi-file program"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gcc 2>/dev/null || true
    echo "TEARDOWN: removed gcc"
fi
echo ""
echo "All gcc Multi-file-compilation tests passed!"
