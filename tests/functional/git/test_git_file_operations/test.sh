#!/bin/sh -eux
# Functional test: git - File-operations

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

echo "=== Test 3: File operations ==="
echo "content1" > file1.txt
rlRun 'git add file1.txt' 0 "git add: stage file"
rlRun 'git status --short' 0 "git status --short"
rlRun 'git commit -m "initial commit"' 0 "git commit: first commit"
rlRun 'git log --oneline' 0 "git log: show commits"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y git 2>/dev/null || true
    echo "TEARDOWN: removed git"
fi
echo ""
echo "All git File-operations tests passed!"
