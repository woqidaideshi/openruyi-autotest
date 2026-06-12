#!/bin/sh -eux
# Functional test: gxx - Include-paths

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

echo "=== Test 10: Include paths ==="
mkdir inc
echo '#define TEST_VAL 42' > inc/test.h
cat > inc_test.cpp << 'EOF'
#include "test.h"
int main() { return TEST_VAL; }
EOF
rlRun 'g++ -I inc inc_test.cpp -o inc_test' 0 "g++ -I: include path"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gxx 2>/dev/null || true
    echo "TEARDOWN: removed gxx"
fi
echo ""
echo "All gxx Include-paths tests passed!"
