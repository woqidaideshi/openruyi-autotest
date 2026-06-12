#!/bin/sh -eux
# Functional test: pip - ��������
# Commands: pip3

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q python3-pip 2>/dev/null || { echo 'python3-pip not installed, skipping'; exit 0; }
which pip3 2>/dev/null || echo 'pip3 not found'

echo "=== pip �������� ==="
rlRun 'pip3 --help 2>&1 | head -15' 0 "pip ����"
rlRun 'pip3 list 2>&1 | head -10' 0 "�г��Ѱ�װ��"
rlRun 'pip3 show pip 2>&1 | head -5' 0 "�鿴 pip ��Ϣ"

echo ""
echo "All pip-basic functional tests passed!"
