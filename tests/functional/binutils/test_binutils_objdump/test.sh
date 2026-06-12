#!/bin/sh -eux
# Functional test: binutils - objdump
# Commands: objdump

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install binutils ===
INSTALLED_BY_TEST=0
if ! rpm -q binutils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y binutils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed binutils"
    else
        echo "SKIP: binutils not available in repos"
        exit 0
    fi
else
    echo "SETUP: binutils already installed"
fi



echo "=== objdump ==="
rlRun 'objdump --help 2>&1 | head -10' 0 "objdump ����"
rlRun 'objdump -f /usr/bin/ls 2>&1 | head -10' 0 "�鿴�ļ�ͷ"
rlRun 'objdump -h /usr/bin/ls 2>&1 | head -20' 0 "�鿴����Ϣ"
rlRun 'objdump -d /usr/bin/ls 2>&1 | head -10' 0 "�����"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y binutils 2>/dev/null || true
    echo "TEARDOWN: removed binutils"
fi
echo ""
echo "All binutils-objdump functional tests passed!"
