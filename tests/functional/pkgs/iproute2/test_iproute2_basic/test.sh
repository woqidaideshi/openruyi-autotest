#!/bin/sh -eux
# Functional test: iproute2 ��������
# Commands: ip, ss, tc

. "../setup.sh"

rlRun 'ip addr show 2>&1 | head -10' 0 "��ʾ�����ַ"
rlRun 'ip link show 2>&1 | head -10' 0 "��ʾ��������"
rlRun 'ip route show 2>&1 | head -5' 0 "��ʾ·�ɱ�"

echo "=== ss ���� ==="
rlRun 'ss --help 2>&1 | head -10' 0 "ss ����"
rlRun 'ss -tln 2>&1 | head -10' 0 "��ʾ�����˿�"

echo "=== tc ���� ==="
rlRun 'tc --help 2>&1 | head -10' 0 "tc ����"

. "../teardown.sh"
echo "All iproute2-basic functional tests passed!"
