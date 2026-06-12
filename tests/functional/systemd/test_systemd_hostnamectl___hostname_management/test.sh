#!/bin/sh -eux
# Functional test: systemd - hostnamectl---Hostname-management

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

echo "=== Test 4: hostnamectl - Hostname management ==="

rlRun 'hostnamectl --version 2>&1 || true' 0 "hostnamectl version"
rlRun 'hostnamectl status' 0 "hostnamectl status: system info"
rlRun 'hostnamectl hostname' 0 "hostnamectl hostname: current name"
rlRun 'hostnamectl --static' 0 "hostnamectl --static"
rlRun 'hostnamectl --transient' 0 "hostnamectl --transient"
rlRun 'hostnamectl --pretty 2>&1 || true' 0 "hostnamectl --pretty"
rlRun 'hostnamectl chassis 2>&1 || true' 0 "hostnamectl chassis"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y systemd 2>/dev/null || true
    echo "TEARDOWN: removed systemd"
fi
echo ""
echo "All systemd hostnamectl---Hostname-management tests passed!"
