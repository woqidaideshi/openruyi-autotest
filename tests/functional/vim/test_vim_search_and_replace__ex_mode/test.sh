#!/bin/sh -eux
# Functional test: vim - Search-and-replace--ex-mode

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q vim-common 2>/dev/null || { echo 'vim-common not installed, skipping'; exit 0; }
which vim 2>/dev/null || echo 'vim not found'
rlRun 'vim --version 2>&1 | head -3' 0 "vim version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: Search and replace (ex mode) ==="
echo "foo bar baz" > search.txt
rlRun 'vim -e -s search.txt -c "%s/bar/XXX/g" -c "wq" 2>&1 || true' 0 "vim: search and replace"
rlRun 'grep -q XXX search.txt' 0 "Replace verified"


echo ""
echo "All vim Search-and-replace--ex-mode tests passed!"
