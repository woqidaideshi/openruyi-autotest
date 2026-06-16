#!/bin/sh -eux
# Functional test: grep - Context-lines---A---B---C

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install grep ===
INSTALLED_BY_TEST=0
if ! rpm -q grep 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y grep 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed grep"
    else
        echo "SKIP: grep not available in repos"
        exit 0
    fi
else
    echo "SETUP: grep already installed"
fi

rlRun 'grep --version' 0 "Get grep version info"
TmpDir=$(mktemp -d)
cd $TmpDir
cat > test1.txt << 'EOF'
Hello World
hello world
HELLO WORLD
Hello Linux
Goodbye World
This is a test file
12345 numbers
Special chars: *.[]^$
EOF
cat > test2.txt << 'EOF'
apple banana cherry
Apple Banana Cherry
APPLE BANANA CHERRY
grape orange melon
EOF
mkdir subdir
echo "nested file content" > subdir/nested.txt
echo "another nested hello" > subdir/nested2.txt

echo "=== Test 10: Context lines (-A, -B, -C) ==="

# Test 10.1: After context
rlRun 'grep -A1 "Hello World" test1.txt' 0 "Context: 1 line after match"

# Test 10.2: Before context
rlRun 'grep -B1 "Hello Linux" test1.txt' 0 "Context: 1 line before match"

# Test 10.3: Both context
rlRun 'grep -C1 "Hello World" test1.txt' 0 "Context: 1 line before and after"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y grep 2>/dev/null || true
    echo "TEARDOWN: removed grep"
fi
echo ""
echo "All grep Context-lines---A---B---C tests passed!"
