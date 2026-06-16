#!/bin/sh -eux
# Functional test: coreutils - File-creation-and-listing--echo--cat--ls--dir--vdi

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install coreutils ===
INSTALLED_BY_TEST=0
if ! rpm -q coreutils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y coreutils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed coreutils"
    else
        echo "SKIP: coreutils not available in repos"
        exit 0
    fi
else
    echo "SETUP: coreutils already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: File creation and listing (echo, cat, ls, dir, vdir) ==="

# 1.1 echo
rlRun 'echo "line1" > file1.txt' 0 "echo create file"
rlRun 'echo "line2" >> file1.txt' 0 "echo append"
rlRun 'echo -n "no_newline" > no_nl.txt' 0 "echo -n suppress newline"
rlRun 'test $(wc -c < no_nl.txt) -eq 10' 0 "echo -n: verify no trailing newline"

# 1.2 cat
rlRun 'cat file1.txt' 0 "cat display file"
rlRun 'test $(cat file1.txt | wc -l) -eq 2' 0 "cat: verify 2 lines"
rlRun 'cat -n file1.txt' 0 "cat -n number all lines"
rlRun 'cat -b file1.txt' 0 "cat -b number non-blank lines"

# 1.3 ls
rlRun 'ls -la' 0 "ls -la list all files"
rlRun 'ls file1.txt' 0 "ls specific file"
rlRun 'ls -l file1.txt | grep -q "^-"' 0 "ls -l: regular file check"
rkTestDir=ls_testdir
mkdir $rkTestDir
rlRun 'ls -ld ls_testdir | grep -q "^d"' 0 "ls -ld: directory check"
rlRun 'ls -1' 0 "ls -1 single column"

# 1.4 dir (equivalent to ls -C -b)
rlRun 'dir' 0 "dir list directory"

# 1.5 vdir (equivalent to ls -l -b)
rlRun 'vdir' 0 "vdir long format list"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y coreutils 2>/dev/null || true
    echo "TEARDOWN: removed coreutils"
fi
echo ""
echo "All coreutils File-creation-and-listing--echo--cat--ls--dir--vdi tests passed!"
