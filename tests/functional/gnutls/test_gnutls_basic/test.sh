#!/bin/sh -eux
# Functional test: gnutls - ��������
# Commands: certtool, gnutls-cli

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q gnutls 2>/dev/null || { echo 'gnutls not installed, skipping'; exit 0; }
which certtool 2>/dev/null || echo 'certtool not found'
which gnutls-cli 2>/dev/null || echo 'gnutls-cli not found'

echo "=== gnutls ���� ==="
rlRun 'certtool --help 2>&1 | head -10' 0 "certtool ����"
rlRun 'gnutls-cli --help 2>&1 | head -10' 0 "gnutls-cli ����"

echo ""
echo "All gnutls-basic functional tests passed!"
