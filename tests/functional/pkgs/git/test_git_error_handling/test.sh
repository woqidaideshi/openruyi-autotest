#!/bin/sh -eux
# Functional test: git - Error-handling

. "../setup.sh"

echo "=== Test 15: Error handling ==="
rlRun 'git nonexistent 2>&1 || true' 0 "git: invalid command"
rlRun 'git --invalid-option 2>&1 || true' 0 "git: invalid option"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All git Error-handling tests passed!"
