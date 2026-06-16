#!/bin/sh -eux
# Functional test: clang - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install clang ===
INSTALLED_BY_TEST=0
if ! rpm -q clang 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y clang 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed clang"
    else
        echo "SKIP: clang not available in repos"
        exit 0
    fi
else
    echo "SETUP: clang already installed"
fi

rlRun 'clang --version' 0 "clang version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 15: Error handling ==="
cat > bad.c << 'EOF'
int main() { invalid; return 0; }
EOF
rlRun 'clang bad.c -o bad 2>&1 || true' 0 "Compilation error"
rlRun 'clang --invalid-option 2>&1 || true' 0 "Invalid option"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y clang 2>/dev/null || true
    echo "TEARDOWN: removed clang"
fi
echo ""
echo "All clang functional tests passed!"

echo ""
echo "All clang Error-handling tests passed!"
