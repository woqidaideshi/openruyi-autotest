#!/bin/sh -eux
# Functional test: gcc - Warning-flags

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

echo "=== Test 7: Warning flags ==="

cat > warn.c << 'EOF'
int main() {
    int x;
    return x;
}
EOF

# Test 7.1: Compile with -Wall
rlRun 'gcc -Wall warn.c -o warn_test 2>&1' 0 "Compile with -Wall warnings enabled"

# Test 7.2: Compile with -Werror (warnings as errors)
rlRun 'gcc -Wall -Werror hello.c -o hello_werr' 0 "Compile with -Werror"

# Test 7.3: Compile with -pedantic
rlRun 'gcc -pedantic hello.c -o hello_pedantic' 0 "Compile with -pedantic"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gcc 2>/dev/null || true
    echo "TEARDOWN: removed gcc"
fi
echo ""
echo "All gcc Warning-flags tests passed!"
