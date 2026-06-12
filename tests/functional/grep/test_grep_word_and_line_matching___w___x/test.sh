#!/bin/sh -eux
# Functional test: grep - Word-and-line-matching---w---x

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

echo "=== Test 4: Word and line matching (-w, -x) ==="

# Test 4.1: Whole word match
rlRun 'echo "helloworld" > word_test.txt' 0 "Create word test file"
rlRun 'echo "hello world" >> word_test.txt' 0 "Add line with separate words"
rlRun 'test $(grep -w hello word_test.txt | wc -l) -eq 1' 0 "Whole word match: hello matches only standalone"

# Test 4.2: Whole line match
rlRun 'echo "exact match" > line_test.txt' 0 "Create line test file"
rlRun 'echo "not exact match here" >> line_test.txt' 0 "Add different line"
rlRun 'test $(grep -x "exact match" line_test.txt | wc -l) -eq 1' 0 "Whole line exact match"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y grep 2>/dev/null || true
    echo "TEARDOWN: removed grep"
fi
echo ""
echo "All grep Word-and-line-matching---w---x tests passed!"
