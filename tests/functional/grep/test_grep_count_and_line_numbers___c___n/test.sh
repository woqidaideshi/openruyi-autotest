#!/bin/sh -eux
# Functional test: grep - Count-and-line-numbers---c---n

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

echo "=== Test 5: Count and line numbers (-c, -n) ==="

# Test 5.1: Count matches
rlRun 'grep -c Hello test1.txt' 0 "Count matches with -c"
rlRun 'test $(grep -c Hello test1.txt) -ge 2' 0 "Verify count >= 2"

# Test 5.2: Line numbers
rlRun 'grep -n Hello test1.txt' 0 "Show line numbers with -n"
rlRun 'grep -n Hello test1.txt | grep -q "^[0-9]:"' 0 "Verify line number format"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y grep 2>/dev/null || true
    echo "TEARDOWN: removed grep"
fi
echo ""
echo "All grep Count-and-line-numbers---c---n tests passed!"
