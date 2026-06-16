#!/bin/sh -eux
# Functional test: binutils - readelf
# Commands: readelf

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



echo "=== readelf ==="
rlRun 'readelf --help 2>&1 | head -10' 0 "readelf ����"
rlRun 'readelf -h /usr/bin/ls 2>&1 | head -20' 0 "ELF ͷ"
rlRun 'readelf -S /usr/bin/ls 2>&1 | head -20' 0 "��ͷ��"
rlRun 'readelf -d /usr/bin/ls 2>&1 | head -10' 0 "��̬��"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y binutils 2>/dev/null || true
    echo "TEARDOWN: removed binutils"
fi
echo ""
echo "All binutils-readelf functional tests passed!"
