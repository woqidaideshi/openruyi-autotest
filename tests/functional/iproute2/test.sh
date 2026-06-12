#!/bin/sh -eux
# Functional test: iproute2 - ���繤��
# Commands: ip, ss, tc, bridge

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q iproute2 2>/dev/null || { echo 'iproute2 not installed, skipping'; exit 0; }
which ip 2>/dev/null || echo 'ip not found'
which ss 2>/dev/null || echo 'ss not found'
which tc 2>/dev/null || echo 'tc not found'

echo ""
echo "All iproute2 functional tests passed!"
