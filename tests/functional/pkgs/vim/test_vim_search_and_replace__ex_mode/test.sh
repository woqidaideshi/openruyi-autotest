#!/bin/sh -eux
# Functional test: vim - Search-and-replace--ex-mode

. "../setup.sh"

echo "=== Test 6: Search and replace (ex mode) ==="
echo "foo bar baz" > search.txt
rlRun 'vim -e -s search.txt -c "%s/bar/XXX/g" -c "wq" 2>&1 || true' 0 "vim: search and replace"
rlRun 'grep -q XXX search.txt' 0 "Replace verified"

. "../teardown.sh"
echo "All vim Search-and-replace--ex-mode tests passed!"
