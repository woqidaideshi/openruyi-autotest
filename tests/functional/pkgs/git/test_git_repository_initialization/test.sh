#!/bin/sh -eux
# Functional test: git - Repository-initialization

. "../setup.sh"

echo "=== Test 1: Repository initialization ==="
rlRun 'git init test_repo' 0 "git init: create repo"
cd test_repo
rlRun 'git status' 0 "git status: check status"
rlRun 'test -d .git' 0 "git init: .git directory exists"

. "../teardown.sh"
echo "All git Repository-initialization tests passed!"
