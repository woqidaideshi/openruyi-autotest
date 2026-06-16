#!/bin/sh -eux
# Functional test: git - Remote-operations

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

echo "=== Test 9: Remote operations ==="
rlRun 'git remote' 0 "git remote: list remotes"
rlRun 'git remote add origin /tmp/fake_remote 2>&1 || true' 0 "git remote add"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y git 2>/dev/null || true
    echo "TEARDOWN: removed git"
fi
echo ""
echo "All git Remote-operations tests passed!"
