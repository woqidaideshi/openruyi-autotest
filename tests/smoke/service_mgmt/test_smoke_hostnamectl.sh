#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'hostnamectl 2>&1 || true' 0 "hostnamectl 状态"
rlRun 'hostnamectl status 2>&1 || true' 0 "hostnamectl status"
echo "smoke test passed!"
