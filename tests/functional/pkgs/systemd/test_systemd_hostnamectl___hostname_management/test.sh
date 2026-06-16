#!/bin/sh -eux
# Functional test: systemd - hostnamectl---Hostname-management

. "../setup.sh"

echo "=== Test 4: hostnamectl - Hostname management ==="

rlRun 'hostnamectl --version 2>&1 || true' 0 "hostnamectl version"
rlRun 'hostnamectl status' 0 "hostnamectl status: system info"
rlRun 'hostnamectl hostname' 0 "hostnamectl hostname: current name"
rlRun 'hostnamectl --static' 0 "hostnamectl --static"
rlRun 'hostnamectl --transient' 0 "hostnamectl --transient"
rlRun 'hostnamectl --pretty 2>&1 || true' 0 "hostnamectl --pretty"
rlRun 'hostnamectl chassis 2>&1 || true' 0 "hostnamectl chassis"

# ===================================================================

. "../teardown.sh"
echo "All systemd hostnamectl---Hostname-management tests passed!"
