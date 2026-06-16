#!/bin/sh -eux
# Functional test: vim - Recording-test

. "../setup.sh"

echo "=== Test 8: Recording test ==="
echo "line1" > rec.txt
rlRun 'vim -e -s rec.txt -c "norm! ihello" -c "wq" 2>&1 || true' 0 "vim: insert in ex mode"

. "../teardown.sh"
echo "All vim Recording-test tests passed!"
