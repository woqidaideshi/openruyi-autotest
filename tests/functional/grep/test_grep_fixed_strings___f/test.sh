#!/bin/sh -eux
# Functional test: grep - Fixed-strings---F

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

echo "=== Test 8: Fixed strings (-F) ==="

# Test 8.1: Fixed string (no regex interpretation)
rlRun 'grep -F "Special chars: *.[]^$" test1.txt' 0 "Fixed string with special chars"
rlRun 'grep -F "*.[]" test1.txt' 0 "Fixed string: no regex meta-char interpretation"

# Test 8.2: fgrep equivalent
rlRun 'fgrep "Special chars" test1.txt' 0 "fgrep equivalent to grep -F"


echo ""
echo "All grep Fixed-strings---F tests passed!"
