#!/bin/sh -eux
# Functional test: coreutils - Counting-and-statistics--wc--du--df--stat

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q coreutils 2>/dev/null || { echo 'coreutils not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: Counting and statistics (wc, du, df, stat) ==="

# 6.1 wc
rlRun 'wc -l lines.txt' 0 "wc -l line count"
rlRun 'test $(wc -l < lines.txt) -eq 20' 0 "wc -l: 20 lines"
rlRun 'wc -c lines.txt' 0 "wc -c byte count"
rlRun 'wc -w lines.txt' 0 "wc -w word count"
rlRun 'wc -m lines.txt' 0 "wc -m character count"

# 6.2 du
rlRun 'du -sh .' 0 "du -sh summary human"
rlRun 'du -h a/' 0 "du -h directory usage"

# 6.3 df
rlRun 'df -h' 0 "df -h human readable"
rlRun 'df -h / | tail -1' 0 "df: root filesystem"

# 6.4 stat
rlRun 'stat file1.txt' 0 "stat file status"
rlRun 'stat -c "%s %n" file1.txt' 0 "stat -c format output"
rlRun 'stat -f /' 0 "stat -f filesystem status"

# ===================================================================

echo ""
echo "All coreutils Counting-and-statistics--wc--du--df--stat tests passed!"
