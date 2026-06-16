#!/bin/sh -eux
# Functional test: git - Log-and-show

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

echo "=== Test 6: Log and show ==="
rlRun 'git log --oneline -3' 0 "git log: last 3 commits"
rlRun 'git log --graph --oneline' 0 "git log --graph"
rlRun 'git show HEAD --stat' 0 "git show: latest commit"
rlRun 'git show HEAD~1 --oneline' 0 "git show: previous commit"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y git 2>/dev/null || true
    echo "TEARDOWN: removed git"
fi
echo ""
echo "All git Log-and-show tests passed!"
