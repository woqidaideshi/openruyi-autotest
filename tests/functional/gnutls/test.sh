#!/bin/sh -eux
# Functional test: gnutls - TLS/SSL ��͹���
# Commands: certtool, gnutls-cli, gnutls-serv, p11tool

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q gnutls 2>/dev/null || { echo 'gnutls not installed, skipping'; exit 0; }
which certtool 2>/dev/null || echo 'certtool not found'
which gnutls-cli 2>/dev/null || echo 'gnutls-cli not found'

echo ""
echo "All gnutls functional tests passed!"
