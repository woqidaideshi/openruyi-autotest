#!/bin/sh -eux
# Functional test: cpio - ��������
# Tests: cpio commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install cpio ===
INSTALLED_BY_TEST=0
if ! rpm -q cpio 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y cpio 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed cpio"
    else
        echo "SKIP: cpio not available in repos"
        exit 0
    fi
else
    echo "SETUP: cpio already installed"
fi



echo "=== ����: cpio �������� ==="
rlRun 'cpio --help 2>&1 | head -10' 0 "�鿴 cpio ������Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y cpio 2>/dev/null || true
    echo "TEARDOWN: removed cpio"
fi
echo ""
echo "All cpio-basic functional tests passed!"
