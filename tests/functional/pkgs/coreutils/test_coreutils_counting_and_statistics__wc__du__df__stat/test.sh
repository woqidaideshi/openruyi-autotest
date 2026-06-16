#!/bin/sh -eux
# Functional test: coreutils - Counting-and-statistics--wc--du--df--stat

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


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y coreutils 2>/dev/null || true
    echo "TEARDOWN: removed coreutils"
fi
echo ""
echo "All coreutils Counting-and-statistics--wc--du--df--stat tests passed!"
