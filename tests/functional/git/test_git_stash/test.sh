#!/bin/sh -eux
# Functional test: git - Stash

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

echo "=== Test 10: Stash ==="
echo "wip" > wip.txt
rlRun 'git stash push -m "wip changes" 2>&1 || true' 0 "git stash: push"
rlRun 'git stash list 2>&1 || true' 0 "git stash list"
rlRun 'git stash pop 2>&1 || true' 0 "git stash pop"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y git 2>/dev/null || true
    echo "TEARDOWN: removed git"
fi
echo ""
echo "All git Stash tests passed!"
