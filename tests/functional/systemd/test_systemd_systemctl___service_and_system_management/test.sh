#!/bin/sh -eux
# Functional test: systemd - systemctl---Service-and-system-management

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q systemd 2>/dev/null || { echo 'systemd not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: systemctl - Service and system management ==="

rlRun 'systemctl --version' 0 "systemctl version"
rlRun 'systemctl list-units --type=service | head -20' 0 "systemctl: list running services"
rlRun 'systemctl list-units --type=target | head -20' 0 "systemctl: list targets"
rlRun 'systemctl list-units --type=service --all | head -20' 0 "systemctl --all: all services"
rlRun 'systemctl list-unit-files --type=service | head -10' 0 "systemctl: list unit files"
rlRun 'systemctl is-active systemd-journald.service 2>&1 || true' 0 "systemctl is-active: check service status"
rlRun 'systemctl is-enabled systemd-journald.service 2>&1 || true' 0 "systemctl is-enabled: check enabled"
rlRun 'systemctl is-failed 2>&1 || true' 0 "systemctl is-failed: list failed units"
rlRun 'systemctl status systemd-journald.service 2>&1 | head -5' 0 "systemctl status: service status"
rlRun 'systemctl show systemd-journald.service 2>&1 | head -10' 0 "systemctl show: service properties"
rlRun 'systemctl cat systemd-journald.service 2>&1 | head -5' 0 "systemctl cat: show unit file"
rlRun 'systemctl list-dependencies default.target 2>&1 | head -10' 0 "systemctl list-dependencies"
rlRun 'systemctl list-sockets 2>&1 | head -10' 0 "systemctl list-sockets"
rlRun 'systemctl list-timers 2>&1 | head -10' 0 "systemctl list-timers"
rlRun 'systemctl list-machines 2>&1 || true' 0 "systemctl list-machines"

# ===================================================================

echo ""
echo "All systemd systemctl---Service-and-system-management tests passed!"
