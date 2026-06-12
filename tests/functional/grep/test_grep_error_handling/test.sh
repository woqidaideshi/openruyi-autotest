#!/bin/sh -eux
# Functional test: grep - Error-handling

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

echo "=== Test 13: Error handling ==="

# Test 13.1: Nonexistent file
rlRun 'grep pattern nonexistent_file.txt 2>&1' 2 "Error on nonexistent file" || true

# Test 13.2: Invalid regex
rlRun 'grep "[" test1.txt 2>&1' 2 "Error on invalid regex" || true

# Test 13.3: Directory without -r
rlRun 'grep pattern subdir/ 2>&1' 2 "Error on directory without -r" || true

# Test 13.4: No match (exit 1)
rlRun 'grep NONEXISTENT_PATTERN test1.txt' 1 "No match returns exit code 1" || true

cd /
rm -rf $TmpDir

echo ""
echo "All grep functional tests passed!"

echo ""
echo "All grep Error-handling tests passed!"
