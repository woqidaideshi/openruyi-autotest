#!/bin/sh -eux
# Functional test: gcc - Basic-C-compilation

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

echo "=== Test 1: Basic C compilation ==="

# Test 1.1: Compile simple C program
cat > hello.c << 'EOF'
#include <stdio.h>
int main() { printf("Hello GCC\n"); return 0; }
EOF
rlRun 'gcc hello.c -o hello' 0 "Compile hello.c to hello"
rlRun './hello' 0 "Run compiled hello"
rlRun 'file hello | grep -i elf' 0 "Verify output is ELF binary"

# Test 1.2: Compile with explicit output name
rlRun 'gcc -o myhello hello.c' 0 "Compile with -o flag"
rlRun './myhello' 0 "Run myhello"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gcc 2>/dev/null || true
    echo "TEARDOWN: removed gcc"
fi
echo ""
echo "All gcc Basic-C-compilation tests passed!"
