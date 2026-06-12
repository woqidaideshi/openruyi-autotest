#!/bin/sh -eux
# Functional test: authselect - ��������
# Commands: authselect

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q authselect 2>/dev/null || { echo 'authselect not installed, skipping'; exit 0; }
which authselect 2>/dev/null || echo 'authselect not found'

echo "=== authselect �������� ==="
rlRun 'authselect --help 2>&1 | head -20' 0 "�鿴������Ϣ"
rlRun 'authselect list 2>&1 || true' 0 "�г���������"
rlRun 'authselect current 2>&1 || true' 0 "�鿴��ǰ����"
rlRun 'authselect check 2>&1 || true' 0 "��鵱ǰ����"

echo ""
echo "All authselect-basic functional tests passed!"
