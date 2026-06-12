#!/bin/sh -eux
# Functional test: git - User-configuration

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q git-core 2>/dev/null || { echo 'git-core not installed, skipping'; exit 0; }
which git 2>/dev/null || echo 'git not found'
rlRun 'git --version' 0 "git version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 2: User configuration ==="
rlRun 'git config user.name "Test User"' 0 "git config: set user name"
rlRun 'git config user.email "test@example.com"' 0 "git config: set email"
rlRun 'git config user.name' 0 "git config: get user name"
rlRun 'git config --list | head -5' 0 "git config --list"


echo ""
echo "All git User-configuration tests passed!"
