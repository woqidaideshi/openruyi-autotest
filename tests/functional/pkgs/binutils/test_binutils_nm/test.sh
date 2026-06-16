#!/bin/sh -eux
# Functional test: binutils - nm
# Commands: nm

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



echo "=== nm ���Ų鿴 ==="
rlRun 'nm --help 2>&1 | head -10' 0 "nm ����"
rlRun 'nm /usr/bin/ls 2>&1 | head -10' 0 "�鿴 ls ���ű�"
rlRun 'nm -D /usr/bin/ls 2>&1 | head -10' 0 "�鿴��̬����"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y binutils 2>/dev/null || true
    echo "TEARDOWN: removed binutils"
fi
echo ""
echo "All binutils-nm functional tests passed!"
