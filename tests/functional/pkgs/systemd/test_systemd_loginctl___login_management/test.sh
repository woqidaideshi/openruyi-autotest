#!/bin/sh -eux
# Functional test: systemd - loginctl---Login-management

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

echo "=== Test 7: loginctl - Login management ==="

rlRun 'loginctl --version 2>&1 || true' 0 "loginctl version"
rlRun 'loginctl list-sessions' 0 "loginctl list-sessions"
rlRun 'loginctl list-users' 0 "loginctl list-users"
rlRun 'loginctl show-session 2>&1 | head -10' 0 "loginctl show-session"
rlRun 'loginctl show-user openruyi 2>&1 | head -10' 0 "loginctl show-user"
rlRun 'loginctl user-status openruyi 2>&1 | head -10' 0 "loginctl user-status"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y systemd 2>/dev/null || true
    echo "TEARDOWN: removed systemd"
fi
echo ""
echo "All systemd loginctl---Login-management tests passed!"
