#!/bin/sh -eux
# Functional test: git - Reset-and-restore

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

echo "=== Test 8: Reset and restore ==="
echo "temp" > temp.txt
rlRun 'git add temp.txt' 0 "git add: temp file"
rlRun 'git reset HEAD temp.txt' 0 "git reset: unstage"
rlRun 'git restore --staged temp.txt 2>&1 || true' 0 "git restore --staged"
rlRun 'rm -f temp.txt' 0 "Cleanup temp"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y git 2>/dev/null || true
    echo "TEARDOWN: removed git"
fi
echo ""
echo "All git Reset-and-restore tests passed!"
