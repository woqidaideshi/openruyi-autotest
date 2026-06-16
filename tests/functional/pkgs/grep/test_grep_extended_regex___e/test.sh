#!/bin/sh -eux
# Functional test: grep - Extended-regex---E

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

echo "=== Test 7: Extended regex (-E) ==="

# Test 7.1: Extended regex alternation
rlRun 'grep -E "apple|banana" test2.txt' 0 "Extended regex with alternation"

# Test 7.2: Extended regex with quantifiers
rlRun 'grep -E "[0-9]+" test1.txt' 0 "Extended regex: digit quantifier"
rlRun 'test $(grep -E "[0-9]+" test1.txt | wc -l) -ge 1' 0 "Verify digit match count"

# Test 7.3: egrep equivalent
rlRun 'egrep "apple|banana" test2.txt' 0 "egrep equivalent to grep -E"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y grep 2>/dev/null || true
    echo "TEARDOWN: removed grep"
fi
echo ""
echo "All grep Extended-regex---E tests passed!"
