#!/bin/sh -eux
# Functional test: bc - ��������
# Tests: bc commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'echo "1+1" | bc' 0 "�����ӷ�"
rlRun 'echo "10-3" | bc' 0 "��������"
rlRun 'echo "6*7" | bc' 0 "�����˷�"
rlRun 'echo "100/3" | bc' 0 "��������"
rlRun 'echo "scale=4; 1/3" | bc' 0 "���þ���"
rlRun 'echo "2^10" | bc' 0 "������"
rlRun 'echo "sqrt(16)" | bc' 0 "ƽ����"

. "../teardown.sh"
echo "All bc-basic functional tests passed!"
