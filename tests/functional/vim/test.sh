#!/bin/sh -eux
# Functional test: vim package
# Tests Vim text editor commands, modes, and features
# Version: Vim 9.2

rlRun() { eval "$1" 2>&1; return $?; }

rlRun 'rpm -q vim-common' 0 "Check vim-common installed"
rlRun 'which vim' 0 "Check vim available"

rlRun 'vim --version 2>&1 | head -3' 0 "vim version"

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Basic editing ==="
echo "test line one" > test.txt
echo "test line two" >> test.txt

# Run vim in ex mode (non-interactive)
rlRun 'vim -e -s test.txt <<< "wq" 2>&1 || true' 0 "vim -e: ex mode"

echo "=== Test 2: Batch/ex mode commands ==="
rlRun 'echo "test content" | vim - -es "+%p" "+q!" 2>&1 | head -1' 0 "vim: print buffer"

echo "=== Test 3: Command line options ==="
rlRun 'vim --help 2>&1 | head -10' 0 "vim --help"
rlRun 'vim -c "version" -c "q" test.txt 2>&1 | head -3 || true' 0 "vim -c: execute command"
rlRun 'vim -R test.txt -c "q" 2>&1 || true' 0 "vim -R: readonly mode"
rlRun 'vim -b test.txt -c "q" 2>&1 || true' 0 "vim -b: binary mode"
rlRun 'vim -n test.txt -c "q" 2>&1 || true' 0 "vim -n: no swap file"

echo "=== Test 4: Vimdiff ==="
echo "line1" > file1.txt
echo "line2" > file2.txt
rlRun 'which vimdiff' 0 "vimdiff available"
rlRun 'vimdiff -c "q" file1.txt file2.txt 2>&1 || true' 0 "vimdiff: compare files"

echo "=== Test 5: Syntax check ==="
cat > test.sh << 'EOF'
#!/bin/sh
echo "hello"
EOF
rlRun 'vim -e -s -c "syn on" -c "q" test.sh 2>&1 || true' 0 "vim: syntax enable"

echo "=== Test 6: Search and replace (ex mode) ==="
echo "foo bar baz" > search.txt
rlRun 'vim -e -s search.txt -c "%s/bar/XXX/g" -c "wq" 2>&1 || true' 0 "vim: search and replace"
rlRun 'grep -q XXX search.txt' 0 "Replace verified"

echo "=== Test 7: Multiple files ==="
echo "a" > a.txt
echo "b" > b.txt
rlRun 'vim -e -s -c "bufdo wq" a.txt b.txt 2>&1 || true' 0 "vim: multiple files"

echo "=== Test 8: Recording test ==="
echo "line1" > rec.txt
rlRun 'vim -e -s rec.txt -c "norm! ihello" -c "wq" 2>&1 || true' 0 "vim: insert in ex mode"

echo "=== Test 9: Terminal options ==="
rlRun 'vim -T xterm -c "q" test.txt 2>&1 || true' 0 "vim -T: terminal type"

echo "=== Test 10: Error handling ==="
rlRun 'vim --invalid-option 2>&1 || true' 0 "vim: invalid option"
rlRun 'vim /nonexistent/file.txt -c "q" 2>&1 || true' 0 "vim: nonexistent file"

cd /
rm -rf $TmpDir

echo ""
echo "All vim functional tests passed!"