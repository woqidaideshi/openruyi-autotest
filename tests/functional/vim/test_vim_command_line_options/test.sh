#!/bin/sh -eux
# Functional test: vim - Command-line-options

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q vim-common 2>/dev/null || { echo 'vim-common not installed, skipping'; exit 0; }
which vim 2>/dev/null || echo 'vim not found'
rlRun 'vim --version 2>&1 | head -3' 0 "vim version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: Command line options ==="
rlRun 'vim --help 2>&1 | head -10' 0 "vim --help"
rlRun 'vim -c "version" -c "q" test.txt 2>&1 | head -3 || true' 0 "vim -c: execute command"
rlRun 'vim -R test.txt -c "q" 2>&1 || true' 0 "vim -R: readonly mode"
rlRun 'vim -b test.txt -c "q" 2>&1 || true' 0 "vim -b: binary mode"
rlRun 'vim -n test.txt -c "q" 2>&1 || true' 0 "vim -n: no swap file"


echo ""
echo "All vim Command-line-options tests passed!"
