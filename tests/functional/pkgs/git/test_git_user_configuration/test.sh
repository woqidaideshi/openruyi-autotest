#!/bin/sh -eux
# Functional test: git - User-configuration

. "../setup.sh"

echo "=== Test 2: User configuration ==="
rlRun 'git config user.name "Test User"' 0 "git config: set user name"
rlRun 'git config user.email "test@example.com"' 0 "git config: set email"
rlRun 'git config user.name' 0 "git config: get user name"
rlRun 'git config --list | head -5' 0 "git config --list"

. "../teardown.sh"
echo "All git User-configuration tests passed!"
