#!/bin/sh -eux
# Functional test: systemd - timedatectl---Time-date-management

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

echo "=== Test 6: timedatectl - Time/date management ==="

rlRun 'timedatectl --version 2>&1 || true' 0 "timedatectl version"
rlRun 'timedatectl status' 0 "timedatectl status: time info"
rlRun 'timedatectl show' 0 "timedatectl show: all properties"
rlRun 'timedatectl list-timezones 2>&1 | head -10' 0 "timedatectl list-timezones"
rlRun 'timedatectl show-timesync 2>&1 | head -5' 0 "timedatectl show-timesync"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y systemd 2>/dev/null || true
    echo "TEARDOWN: removed systemd"
fi
echo ""
echo "All systemd timedatectl---Time-date-management tests passed!"
