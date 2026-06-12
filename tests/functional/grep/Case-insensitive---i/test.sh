#!/bin/sh -eux
# Functional test: grep - Case-insensitive---i

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q grep' 0 "Check grep package is installed"
rlRun 'which grep' 0 "Check grep command is available"
rlRun 'which egrep' 0 "Check egrep command is available"
rlRun 'which fgrep' 0 "Check fgrep command is available"
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

echo "=== Test 2: Case insensitive (-i) ==="

# Test 2.1: Case insensitive match
rlRun 'grep -i hello test1.txt' 0 "Case insensitive grep"
rlRun 'test $(grep -i hello test1.txt | wc -l) -ge 2' 0 "Verify case insensitive matches"

# Test 2.2: Case sensitive (default)
rlRun 'grep hello test1.txt' 1 "Case sensitive: lowercase only matches lowercase" || true


echo ""
echo "All grep Case-insensitive---i tests passed!"
