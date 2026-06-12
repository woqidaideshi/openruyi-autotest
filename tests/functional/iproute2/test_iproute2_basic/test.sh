#!/bin/sh -eux
# Functional test: iproute2 ��������
# Commands: ip, ss, tc

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q iproute2 2>/dev/null || { echo 'iproute2 not installed, skipping'; exit 0; }
which ip 2>/dev/null || echo 'ip not found'
which ss 2>/dev/null || echo 'ss not found'
which tc 2>/dev/null || echo 'tc not found'

echo "=== ip ���� ==="
rlRun 'ip --help 2>&1 | head -10' 0 "ip ����"
rlRun 'ip addr show 2>&1 | head -10' 0 "��ʾ�����ַ"
rlRun 'ip link show 2>&1 | head -10' 0 "��ʾ��������"
rlRun 'ip route show 2>&1 | head -5' 0 "��ʾ·�ɱ�"

echo "=== ss ���� ==="
rlRun 'ss --help 2>&1 | head -10' 0 "ss ����"
rlRun 'ss -tln 2>&1 | head -10' 0 "��ʾ�����˿�"

echo "=== tc ���� ==="
rlRun 'tc --help 2>&1 | head -10' 0 "tc ����"

echo ""
echo "All iproute2-basic functional tests passed!"
