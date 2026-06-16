#!/bin/sh -eux
# Functional test: coreutils - Special-utilities--stty--pathchk--tsort--ptx--dirc

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

echo "=== Test 23: Special utilities (stty, pathchk, tsort, ptx, dircolors) ==="

# 23.1 stty
rlRun 'stty -a' 0 "stty -a show all terminal settings"

# 23.2 pathchk
rlRun 'pathchk /tmp' 0 "pathchk validate path"
rlRun 'pathchk -p /tmp' 0 "pathchk -p POSIX check"

# 23.3 tsort
rlRun 'echo -e "a b\nb c" | tsort' 0 "tsort topological sort"

# 23.4 ptx
rlRun 'ptx fruits.txt' 0 "ptx permuted index"

# 23.5 dircolors
rlRun 'dircolors -p' 0 "dircolors -p print database"
rlRun 'dircolors' 0 "dircolors output LS_COLORS"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y coreutils 2>/dev/null || true
    echo "TEARDOWN: removed coreutils"
fi
echo ""
echo "All coreutils Special-utilities--stty--pathchk--tsort--ptx--dirc tests passed!"
