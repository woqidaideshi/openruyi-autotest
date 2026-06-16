#!/bin/sh -eux
# Functional test: git - User-configuration

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install git ===
INSTALLED_BY_TEST=0
if ! rpm -q git 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y git 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed git"
    else
        echo "SKIP: git not available in repos"
        exit 0
    fi
else
    echo "SETUP: git already installed"
fi

rlRun 'git --version' 0 "git version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 2: User configuration ==="
rlRun 'git config user.name "Test User"' 0 "git config: set user name"
rlRun 'git config user.email "test@example.com"' 0 "git config: set email"
rlRun 'git config user.name' 0 "git config: get user name"
rlRun 'git config --list | head -5' 0 "git config --list"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y git 2>/dev/null || true
    echo "TEARDOWN: removed git"
fi
echo ""
echo "All git User-configuration tests passed!"
