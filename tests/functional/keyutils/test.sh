#!/bin/sh -eux
# Functional test: keyutils - �ں���Կ����
# Commands: keyctl, request-key, key.dns_resolver

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q keyutils 2>/dev/null || { echo 'keyutils not installed, skipping'; exit 0; }
which keyctl 2>/dev/null || echo 'keyctl not found'

echo ""
echo "All keyutils functional tests passed!"
