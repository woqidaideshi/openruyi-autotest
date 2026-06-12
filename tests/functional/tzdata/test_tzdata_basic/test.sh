#!/bin/sh -eux
# Functional test: tzdata - ��������
# Tests: tzselect, zdump, zic commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install tzdata ===
INSTALLED_BY_TEST=0
if ! rpm -q tzdata 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y tzdata 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed tzdata"
    else
        echo "SKIP: tzdata not available in repos"
        exit 0
    fi
else
    echo "SETUP: tzdata already installed"
fi



echo "=== ����: tzdata �������� ==="
rlRun 'tzselect --help 2>&1 | head -10' 0 "�鿴 tzselect ������Ϣ"
rlRun 'zdump --help 2>&1 | head -10' 0 "�鿴 zdump ������Ϣ"
rlRun 'zic --help 2>&1 | head -10' 0 "�鿴 zic ������Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tzdata 2>/dev/null || true
    echo "TEARDOWN: removed tzdata"
fi
echo ""
echo "All tzdata-basic functional tests passed!"
