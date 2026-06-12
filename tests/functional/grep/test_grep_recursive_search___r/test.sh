#!/bin/sh -eux
# Functional test: grep - Recursive-search---r

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

echo "=== Test 6: Recursive search (-r) ==="

# Test 6.1: Recursive search
rlRun 'grep -r nested subdir/' 0 "Recursive grep in subdirectory"
rlRun 'grep -rl hello subdir/' 0 "Recursive list files with matches"

# Test 6.2: Include/exclude patterns
rlRun 'grep -r --include="*.txt" hello .' 0 "Recursive with --include filter"


echo ""
echo "All grep Recursive-search---r tests passed!"
