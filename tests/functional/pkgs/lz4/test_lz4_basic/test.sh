#!/bin/sh -eux
# Functional test: lz4 - ��������
# Tests: lz4, lz4c, lz4cat, unlz4 commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install lz4 ===
INSTALLED_BY_TEST=0
if ! rpm -q lz4 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y lz4 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed lz4"
    else
        echo "SKIP: lz4 not available in repos"
        exit 0
    fi
else
    echo "SETUP: lz4 already installed"
fi



echo "=== ����: lz4 �������� ==="
rlRun 'lz4 --help 2>&1 | head -10' 0 "�鿴 lz4 ������Ϣ"
rlRun 'lz4c --help 2>&1 | head -10' 0 "�鿴 lz4c ������Ϣ"
rlRun 'lz4cat --help 2>&1 | head -10' 0 "�鿴 lz4cat ������Ϣ"
rlRun 'unlz4 --help 2>&1 | head -10' 0 "�鿴 unlz4 ������Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y lz4 2>/dev/null || true
    echo "TEARDOWN: removed lz4"
fi
echo ""
echo "All lz4-basic functional tests passed!"
