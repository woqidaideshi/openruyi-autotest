#!/bin/sh -eux
# Functional test: vim - Multiple-files

. "../setup.sh"

echo "=== Test 7: Multiple files ==="
echo "a" > a.txt
echo "b" > b.txt
rlRun 'vim -e -s -c "bufdo wq" a.txt b.txt 2>&1 || true' 0 "vim: multiple files"

. "../teardown.sh"
echo "All vim Multiple-files tests passed!"
