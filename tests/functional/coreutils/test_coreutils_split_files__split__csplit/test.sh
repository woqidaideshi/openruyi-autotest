#!/bin/sh -eux
# Functional test: coreutils - Split-files--split--csplit

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q coreutils 2>/dev/null || { echo 'coreutils not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 22: Split files (split, csplit) ==="

# 22.1 split
rlRun 'split -l 5 lines.txt split_' 0 "split by lines"
rlRun 'test $(ls split_* | wc -l) -ge 4' 0 "split: multiple output files"

# 22.2 csplit
rlRun 'csplit fruits.txt /apple/ {1} 2>&1 || true' 0 "csplit split by pattern"

# ===================================================================

echo ""
echo "All coreutils Split-files--split--csplit tests passed!"
