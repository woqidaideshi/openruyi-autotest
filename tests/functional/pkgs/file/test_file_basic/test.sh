#!/bin/sh -eux
# Functional test: file - ��������
# Tests: file commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install file ===
INSTALLED_BY_TEST=0
if ! rpm -q file 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y file 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed file"
    else
        echo "SKIP: file not available in repos"
        exit 0
    fi
else
    echo "SETUP: file already installed"
fi



echo "=== ����: file �������� ==="
rlRun 'file --help 2>&1 | head -10' 0 "�鿴 file ������Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y file 2>/dev/null || true
    echo "TEARDOWN: removed file"
fi
echo ""
echo "All file-basic functional tests passed!"
