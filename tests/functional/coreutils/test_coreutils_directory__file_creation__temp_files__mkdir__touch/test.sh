#!/bin/sh -eux
# Functional test: coreutils - Directory--file-creation--temp-files--mkdir--touch

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

echo "=== Test 3: Directory, file creation, temp files (mkdir, touch, mktemp) ==="

# 3.1 mkdir
rlRun 'mkdir -p a/b/c' 0 "mkdir -p nested directories"
rlRun 'test -d a/b/c' 0 "mkdir -p: verify nested dir"
rlRun 'mkdir -m 755 mode_dir' 0 "mkdir -m set mode"

# 3.2 touch
rlRun 'touch newfile.txt' 0 "touch create file"
rlRun 'test -f newfile.txt' 0 "touch: file exists"
rlRun 'touch -t 202001010000 newfile.txt' 0 "touch -t set timestamp"
rlRun 'touch -a newfile.txt' 0 "touch -a access time only"

# 3.3 mktemp
rlRun 'mktemp' 0 "mktemp create temp file"
mktemp_f=$(mktemp)
rlRun 'test -f $mktemp_f' 0 "mktemp: temp file exists"
rlRun 'mktemp -d' 0 "mktemp -d create temp directory"
rm -f $mktemp_f

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y coreutils 2>/dev/null || true
    echo "TEARDOWN: removed coreutils"
fi
echo ""
echo "All coreutils Directory--file-creation--temp-files--mkdir--touch tests passed!"
