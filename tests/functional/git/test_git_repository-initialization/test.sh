#!/bin/sh -eux
# Functional test: git - Repository-initialization

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q git-core' 0 "Check git-core installed"
rlRun 'which git' 0 "Check git available"
rlRun 'git --version' 0 "git version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Repository initialization ==="
rlRun 'git init test_repo' 0 "git init: create repo"
cd test_repo
rlRun 'git status' 0 "git status: check status"
rlRun 'test -d .git' 0 "git init: .git directory exists"


echo ""
echo "All git Repository-initialization tests passed!"
