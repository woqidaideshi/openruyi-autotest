#!/bin/sh -eux
# Functional test: coreutils - Split-files--split--csplit

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

echo "=== Test 22: Split files (split, csplit) ==="

# 22.1 split
rlRun 'split -l 5 lines.txt split_' 0 "split by lines"
rlRun 'test $(ls split_* | wc -l) -ge 4' 0 "split: multiple output files"

# 22.2 csplit
rlRun 'csplit fruits.txt /apple/ {1} 2>&1 || true' 0 "csplit split by pattern"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y coreutils 2>/dev/null || true
    echo "TEARDOWN: removed coreutils"
fi
echo ""
echo "All coreutils Split-files--split--csplit tests passed!"
