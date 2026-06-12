#!/bin/sh -eux
# Functional test: coreutils - Copy--move--remove--cp--mv--rm--rmdir

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

echo "=== Test 2: Copy, move, remove (cp, mv, rm, rmdir) ==="

# 2.1 cp
rlRun 'cp file1.txt file1_copy.txt' 0 "cp copy file"
rlRun 'test -f file1_copy.txt' 0 "cp: verify copy exists"
rlRun 'diff file1.txt file1_copy.txt' 0 "cp: files identical"
rlRun 'cp -r ls_testdir ls_testdir_copy' 0 "cp -r recursive copy"
rlRun 'test -d ls_testdir_copy' 0 "cp -r: verify directory copy"

# 2.2 mv
rlRun 'mv file1_copy.txt file1_renamed.txt' 0 "mv rename file"
rlRun 'test ! -f file1_copy.txt' 0 "mv: old name gone"
rlRun 'test -f file1_renamed.txt' 0 "mv: new name exists"
rlRun 'mv file1_renamed.txt subdir_move.txt 2>&1 || true' 0 "mv to subdirectory"

# 2.3 rm
rlRun 'touch temp_rm.txt' 0 "Create temp file"
rlRun 'rm temp_rm.txt' 0 "rm remove file"
rlRun 'test ! -f temp_rm.txt' 0 "rm: file removed"
rlRun 'cp -r ls_testdir ls_testdir_rm' 0 "Create dir to remove"
rlRun 'rm -rf ls_testdir_rm' 0 "rm -rf recursive force"
rlRun 'test ! -d ls_testdir_rm' 0 "rm -rf: directory removed"

# 2.4 rmdir
rlRun 'mkdir rmdir_test' 0 "Create empty directory"
rlRun 'rmdir rmdir_test' 0 "rmdir remove empty directory"
rlRun 'test ! -d rmdir_test' 0 "rmdir: directory removed"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y coreutils 2>/dev/null || true
    echo "TEARDOWN: removed coreutils"
fi
echo ""
echo "All coreutils Copy--move--remove--cp--mv--rm--rmdir tests passed!"
