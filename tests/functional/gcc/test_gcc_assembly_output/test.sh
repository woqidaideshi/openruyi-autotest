#!/bin/sh -eux
# Functional test: gcc - Assembly-output

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

echo "=== Test 5: Assembly output ==="

# Test 5.1: Generate assembly (-S)
rlRun 'gcc -S hello.c -o hello.s' 0 "Generate assembly with -S"
rlRun 'grep -q "main:" hello.s' 0 "Check main label in assembly"

# Test 5.2: Assemble .s file to object
rlRun 'as hello.s -o hello_obj.o' 0 "Assemble to object file"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gcc 2>/dev/null || true
    echo "TEARDOWN: removed gcc"
fi
echo ""
echo "All gcc Assembly-output tests passed!"
