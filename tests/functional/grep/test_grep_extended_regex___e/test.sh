#!/bin/sh -eux
# Functional test: grep - Extended-regex---E

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q grep 2>/dev/null || { echo 'grep not installed, skipping'; exit 0; }
which grep 2>/dev/null || echo 'grep not found'
which egrep 2>/dev/null || echo 'egrep not found'
which fgrep 2>/dev/null || echo 'fgrep not found'
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


echo ""
echo "All grep Extended-regex---E tests passed!"
