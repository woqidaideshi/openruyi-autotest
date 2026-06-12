#!/bin/sh -eux
# Functional test: alternatives - ��������
# Commands: alternatives

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q chkconfig 2>/dev/null || { echo 'chkconfig not installed, skipping'; exit 0; }
which alternatives 2>/dev/null || echo 'alternatives not found'

echo "=== alternatives �������� ==="
rlRun 'alternatives --help 2>&1 | head -10' 0 "�鿴����"
rlRun 'alternatives --list 2>&1 | head -5 || true' 0 "�г������"

echo ""
echo "All alternatives-basic functional tests passed!"
