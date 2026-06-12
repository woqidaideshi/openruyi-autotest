#!/bin/sh -eux
# Functional test: git - File-modifications

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

echo "=== Test 5: File modifications ==="
echo "content2" > file2.txt
rlRun 'git add file2.txt' 0 "git add: second file"
rlRun 'git commit -m "add file2"' 0 "git commit: second commit"
echo "modified" >> file1.txt
rlRun 'git diff' 0 "git diff: show changes"
rlRun 'git diff --cached' 0 "git diff --cached: staged changes"
rlRun 'git add file1.txt && git commit -m "modify file1"' 0 "git commit: modify"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y git 2>/dev/null || true
    echo "TEARDOWN: removed git"
fi
echo ""
echo "All git File-modifications tests passed!"
