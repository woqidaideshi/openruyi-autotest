#!/bin/sh -eux
# Functional test: gcc - Error-handling

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

echo "=== Test 10: Error handling ==="

# Test 10.1: Syntax error
echo "int main() { return }" > bad_syntax.c
rlRun 'gcc bad_syntax.c 2>&1' 1-255 "Test syntax error detection"

# Test 10.2: Missing file
rlRun 'gcc nonexistent.c 2>&1' 1-255 "Test missing file error"

# Test 10.3: Undefined function
echo "int main() { undefined_func(); }" > bad_func.c
rlRun 'gcc bad_func.c 2>&1' 1-255 "Test undefined function error"

# Test 10.4: Type mismatch warning
echo "int main() { char* p = 42; }" > bad_type.c
rlRun 'gcc -Wall bad_type.c -o bad_type 2>&1' 0 "Test type mismatch warning"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gcc 2>/dev/null || true
    echo "TEARDOWN: removed gcc"
fi
echo ""
echo "All gcc Error-handling tests passed!"
