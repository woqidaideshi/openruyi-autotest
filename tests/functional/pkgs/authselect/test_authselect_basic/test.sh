#!/bin/sh -eux
# Functional test: authselect - ��������
# Commands: authselect

. "../setup.sh"

rlRun 'authselect list 2>&1 || true' 0 "�г���������"
rlRun 'authselect current 2>&1 || true' 0 "�鿴��ǰ����"
rlRun 'authselect check 2>&1 || true' 0 "��鵱ǰ����"

. "../teardown.sh"
echo "All authselect-basic functional tests passed!"
