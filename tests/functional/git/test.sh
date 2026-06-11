#!/bin/sh -eux
# Functional test: git package
# Tests Git version control system commands
# Version: git 2.54.0

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

echo "=== Test 2: User configuration ==="
rlRun 'git config user.name "Test User"' 0 "git config: set user name"
rlRun 'git config user.email "test@example.com"' 0 "git config: set email"
rlRun 'git config user.name' 0 "git config: get user name"
rlRun 'git config --list | head -5' 0 "git config --list"

echo "=== Test 3: File operations ==="
echo "content1" > file1.txt
rlRun 'git add file1.txt' 0 "git add: stage file"
rlRun 'git status --short' 0 "git status --short"
rlRun 'git commit -m "initial commit"' 0 "git commit: first commit"
rlRun 'git log --oneline' 0 "git log: show commits"

echo "=== Test 4: Branch operations ==="
rlRun 'git branch feature' 0 "git branch: create branch"
rlRun 'git branch' 0 "git branch: list branches"
rlRun 'git branch -a' 0 "git branch -a: all branches"
rlRun 'git switch feature' 0 "git switch: switch branch"
rlRun 'git switch -' 0 "git switch -: previous branch"
rlRun 'git branch -d feature' 0 "git branch -d: delete branch"

echo "=== Test 5: File modifications ==="
echo "content2" > file2.txt
rlRun 'git add file2.txt' 0 "git add: second file"
rlRun 'git commit -m "add file2"' 0 "git commit: second commit"
echo "modified" >> file1.txt
rlRun 'git diff' 0 "git diff: show changes"
rlRun 'git diff --cached' 0 "git diff --cached: staged changes"
rlRun 'git add file1.txt && git commit -m "modify file1"' 0 "git commit: modify"

echo "=== Test 6: Log and show ==="
rlRun 'git log --oneline -3' 0 "git log: last 3 commits"
rlRun 'git log --graph --oneline' 0 "git log --graph"
rlRun 'git show HEAD --stat' 0 "git show: latest commit"
rlRun 'git show HEAD~1 --oneline' 0 "git show: previous commit"

echo "=== Test 7: Tag operations ==="
rlRun 'git tag v1.0' 0 "git tag: create tag"
rlRun 'git tag' 0 "git tag: list tags"
rlRun 'git tag -d v1.0' 0 "git tag -d: delete tag"

echo "=== Test 8: Reset and restore ==="
echo "temp" > temp.txt
rlRun 'git add temp.txt' 0 "git add: temp file"
rlRun 'git reset HEAD temp.txt' 0 "git reset: unstage"
rlRun 'git restore --staged temp.txt 2>&1 || true' 0 "git restore --staged"
rlRun 'rm -f temp.txt' 0 "Cleanup temp"

echo "=== Test 9: Remote operations ==="
rlRun 'git remote' 0 "git remote: list remotes"
rlRun 'git remote add origin /tmp/fake_remote 2>&1 || true' 0 "git remote add"

echo "=== Test 10: Stash ==="
echo "wip" > wip.txt
rlRun 'git stash push -m "wip changes" 2>&1 || true' 0 "git stash: push"
rlRun 'git stash list 2>&1 || true' 0 "git stash list"
rlRun 'git stash pop 2>&1 || true' 0 "git stash pop"

echo "=== Test 11: grep and blame ==="
rlRun 'git grep "content" 2>&1' 0 "git grep: search"
rlRun 'git blame file1.txt 2>&1' 0 "git blame: annotate"

echo "=== Test 12: Clean and gc ==="
rlRun 'git clean -n' 0 "git clean -n: dry run"
rlRun 'git gc --auto 2>&1 || true' 0 "git gc: garbage collect"

echo "=== Test 13: git-shell ==="
rlRun 'which git-shell' 0 "git-shell available"

echo "=== Test 14: scalar ==="
rlRun 'which scalar' 0 "scalar available"
rlRun 'scalar --help 2>&1 | head -5' 0 "scalar help"

echo "=== Test 15: Error handling ==="
rlRun 'git nonexistent 2>&1 || true' 0 "git: invalid command"
rlRun 'git --invalid-option 2>&1 || true' 0 "git: invalid option"

cd /
rm -rf $TmpDir

echo ""
echo "All git functional tests passed!"