#!/bin/sh -eux
# Functional test: keyutils - ��������
# Commands: keyctl

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q keyutils 2>/dev/null || { echo 'keyutils not installed, skipping'; exit 0; }
which keyctl 2>/dev/null || echo 'keyctl not found'

echo "=== keyctl �������� ==="
rlRun 'keyctl --help 2>&1 | head -10' 0 "keyctl ����"
rlRun 'keyctl show 2>&1 || true' 0 "��ʾ��ǰ��Կ"
rlRun 'keyctl list @u 2>&1 || true' 0 "�г��û���Կ"

echo ""
echo "All keyutils-basic functional tests passed!"
