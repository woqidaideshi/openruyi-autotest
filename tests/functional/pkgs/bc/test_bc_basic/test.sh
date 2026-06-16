#!/bin/sh -eux
# Functional test: bc - ��������
# Tests: bc commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install bc ===
INSTALLED_BY_TEST=0
if ! rpm -q bc 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y bc 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed bc"
    else
        echo "SKIP: bc not available in repos"
        exit 0
    fi
else
    echo "SETUP: bc already installed"
fi



echo "=== ����: bc �������� ==="
rlRun 'echo "1+1" | bc' 0 "�����ӷ�"
rlRun 'echo "10-3" | bc' 0 "��������"
rlRun 'echo "6*7" | bc' 0 "�����˷�"
rlRun 'echo "100/3" | bc' 0 "��������"
rlRun 'echo "scale=4; 1/3" | bc' 0 "���þ���"
rlRun 'echo "2^10" | bc' 0 "������"
rlRun 'echo "sqrt(16)" | bc' 0 "ƽ����"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y bc 2>/dev/null || true
    echo "TEARDOWN: removed bc"
fi
echo ""
echo "All bc-basic functional tests passed!"
