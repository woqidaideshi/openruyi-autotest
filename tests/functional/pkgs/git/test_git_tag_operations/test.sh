#!/bin/sh -eux
# Functional test: git - Tag-operations

. "../setup.sh"

echo "=== Test 7: Tag operations ==="
rlRun 'git tag v1.0' 0 "git tag: create tag"
rlRun 'git tag' 0 "git tag: list tags"
rlRun 'git tag -d v1.0' 0 "git tag -d: delete tag"

. "../teardown.sh"
echo "All git Tag-operations tests passed!"
