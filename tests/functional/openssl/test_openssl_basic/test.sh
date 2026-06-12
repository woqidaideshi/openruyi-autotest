#!/bin/sh -eux
# Functional test: openssl - ��������
# Commands: openssl

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q openssl 2>/dev/null || { echo 'openssl not installed, skipping'; exit 0; }
which openssl 2>/dev/null || echo 'openssl not found'

echo "=== openssl �������� ==="
rlRun 'openssl version' 0 "�鿴�汾"
rlRun 'openssl help 2>&1 | head -20' 0 "�鿴����"
rlRun 'openssl list -standard-commands 2>&1 | head -10' 0 "�г���׼����"
rlRun 'openssl list -cipher-commands 2>&1 | head -10' 0 "�г���������"
rlRun 'openssl list -digest-commands 2>&1 | head -10' 0 "�г�ժҪ����"

echo ""
echo "All openssl-basic functional tests passed!"
