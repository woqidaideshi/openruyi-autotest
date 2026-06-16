#!/bin/sh -eux
# Functional test: gcc - Preprocessor

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

echo "=== Test 4: Preprocessor ==="

cat > macro.c << 'EOF'
#define GREETING "Hello Preprocessor"
#include <stdio.h>
int main() { printf("%s\n", GREETING); return 0; }
EOF

# Test 4.1: Preprocess only (-E)
rlRun 'gcc -E macro.c -o macro.i' 0 "Preprocess with -E"
rlRun 'grep "Hello Preprocessor" macro.i' 0 "Verify macro expanded in preprocessed output"

# Test 4.2: Compile preprocessed file
rlRun 'gcc macro.i -o macro_bin' 0 "Compile preprocessed .i file"
rlRun './macro_bin' 0 "Run from preprocessed source"

# Test 4.3: Define macro on command line (-D)
rlRun 'gcc -DTEST_VAL=42 hello.c -o hello_def' 0 "Compile with -D flag"
rlRun './hello_def' 0 "Run with -D defined macro"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gcc 2>/dev/null || true
    echo "TEARDOWN: removed gcc"
fi
echo ""
echo "All gcc Preprocessor tests passed!"
