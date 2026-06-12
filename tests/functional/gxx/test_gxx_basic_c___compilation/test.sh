#!/bin/sh -eux
# Functional test: gxx - Basic-C---compilation

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



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gxx 2>/dev/null || true
    echo "TEARDOWN: removed gxx"
fi
echo ""
echo "All gxx Basic-C---compilation tests passed!"
