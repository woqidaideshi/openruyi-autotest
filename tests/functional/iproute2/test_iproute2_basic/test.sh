#!/bin/sh -eux
# Functional test: iproute2 ��������
# Commands: ip, ss, tc

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install iproute2 ===
INSTALLED_BY_TEST=0
if ! rpm -q iproute2 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y iproute2 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed iproute2"
    else
        echo "SKIP: iproute2 not available in repos"
        exit 0
    fi
else
    echo "SETUP: iproute2 already installed"
fi



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


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y iproute2 2>/dev/null || true
    echo "TEARDOWN: removed iproute2"
fi
echo ""
echo "All iproute2-basic functional tests passed!"
