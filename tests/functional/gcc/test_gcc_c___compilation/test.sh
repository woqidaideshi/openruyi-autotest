#!/bin/sh -eux
# Functional test: gcc - C---compilation

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

echo "=== Test 2: C++ compilation ==="
# Simple C++ test (no iostream to avoid slow header compilation on riscv64)
cat > hello2.cpp << 'EOF'
int main() { return 0; }
EOF
rlRun 'g++ hello2.cpp -o hellocpp' 0 "Compile hello.cpp"
rlRun 'g++ -std=c++11 hello2.cpp -o hellocpp11' 0 "Compile with C++11 standard"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gcc 2>/dev/null || true
    echo "TEARDOWN: removed gcc"
fi
echo ""
echo "All gcc C---compilation tests passed!"
