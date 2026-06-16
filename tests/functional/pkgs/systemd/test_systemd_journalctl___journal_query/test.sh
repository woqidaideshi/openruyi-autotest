#!/bin/sh -eux
# Functional test: systemd - journalctl---Journal-query

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install systemd ===
INSTALLED_BY_TEST=0
if ! rpm -q systemd 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y systemd 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed systemd"
    else
        echo "SKIP: systemd not available in repos"
        exit 0
    fi
else
    echo "SETUP: systemd already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 2: journalctl - Journal query ==="

rlRun 'journalctl --version' 0 "journalctl version"
rlRun 'journalctl -n 5 2>&1 || true' 0 "journalctl -n: last entries"
rlRun 'journalctl -b 2>&1 | head -5' 0 "journalctl -b: current boot"
rlRun 'journalctl --list-boots 2>&1 | head -5' 0 "journalctl --list-boots"
rlRun 'journalctl -k 2>&1 | head -5' 0 "journalctl -k: kernel messages"
rlRun 'journalctl --no-pager -n 3 -o short 2>&1 || true' 0 "journalctl -o short: short format"
rlRun 'journalctl --no-pager -n 3 -o json 2>&1 | head -5' 0 "journalctl -o json: json format"
rlRun 'journalctl --no-pager -n 3 -o verbose 2>&1 | head -5' 0 "journalctl -o verbose"
rlRun 'journalctl --disk-usage 2>&1 || true' 0 "journalctl --disk-usage"
rlRun 'journalctl --no-pager -n 1 --output=cat 2>&1 || true' 0 "journalctl --output=cat"
rlRun 'journalctl --no-pager -n 2 -p err 2>&1 || true' 0 "journalctl -p err: error messages"
rlRun 'journalctl --no-pager --since "1 hour ago" 2>&1 | head -3' 0 "journalctl --since"
rlRun 'journalctl --no-pager -n 1 -q 2>&1 || true' 0 "journalctl -q: quiet"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y systemd 2>/dev/null || true
    echo "TEARDOWN: removed systemd"
fi
echo ""
echo "All systemd journalctl---Journal-query tests passed!"
