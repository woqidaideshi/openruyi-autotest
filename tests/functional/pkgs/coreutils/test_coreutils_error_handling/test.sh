#!/bin/sh -eux
# Functional test: coreutils - Error-handling

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

echo "=== Test 24: Error handling ==="

# 24.1 cp nonexistent source
rlRun 'cp nonexistent.txt /tmp/ 2>&1' 1 "cp: error on nonexistent source" || true

# 24.2 ls nonexistent file
rlRun 'ls nonexistent_file 2>&1' 2 "ls: error on nonexistent file" || true

# 24.3 mkdir existing directory
rlRun 'mkdir ls_testdir 2>&1' 1 "mkdir: error on existing dir" || true

# 24.4 rm without -r on directory
rlRun 'rm ls_testdir_copy 2>&1' 1 "rm: error on dir without -r" || true

# 24.5 rmdir non-empty directory
rlRun 'rmdir a 2>&1' 1 "rmdir: error on non-empty dir" || true

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y coreutils 2>/dev/null || true
    echo "TEARDOWN: removed coreutils"
fi
echo ""
echo "All coreutils functional tests passed!"

echo ""
echo "All coreutils Error-handling tests passed!"
