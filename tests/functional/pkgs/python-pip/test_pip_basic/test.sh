#!/bin/sh -eux
# Functional test: pip - ��������
# Commands: pip3

. "../setup.sh"

rlRun 'pip3 list 2>&1 | head -10' 0 "�г��Ѱ�װ��"
rlRun 'pip3 show pip 2>&1 | head -5' 0 "�鿴 pip ��Ϣ"

. "../teardown.sh"
echo "All pip-basic functional tests passed!"
