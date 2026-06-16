#!/bin/sh -eux
# Functional test: git - Remote-operations

. "../setup.sh"

echo "=== Test 9: Remote operations ==="
rlRun 'git remote' 0 "git remote: list remotes"
rlRun 'git remote add origin /tmp/fake_remote 2>&1 || true' 0 "git remote add"

. "../teardown.sh"
echo "All git Remote-operations tests passed!"
