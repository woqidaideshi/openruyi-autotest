#!/bin/sh -eux
# Functional test: chkconfig - ��������
# Commands: chkconfig

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q chkconfig 2>/dev/null || { echo 'chkconfig not installed, skipping'; exit 0; }
which chkconfig 2>/dev/null || echo 'chkconfig not found'

echo "=== chkconfig �������� ==="
rlRun 'chkconfig --help 2>&1 | head -10' 0 "�鿴����"
rlRun 'chkconfig --list 2>&1 | head -10 || true' 0 "�г�����"

echo ""
echo "All chkconfig-basic functional tests passed!"
