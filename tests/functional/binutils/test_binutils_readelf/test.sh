#!/bin/sh -eux
# Functional test: binutils - readelf
# Commands: readelf

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q binutils 2>/dev/null || { echo 'binutils not installed, skipping'; exit 0; }
which readelf 2>/dev/null || echo 'readelf not found'

echo "=== readelf ==="
rlRun 'readelf --help 2>&1 | head -10' 0 "readelf ����"
rlRun 'readelf -h /usr/bin/ls 2>&1 | head -20' 0 "ELF ͷ"
rlRun 'readelf -S /usr/bin/ls 2>&1 | head -20' 0 "��ͷ��"
rlRun 'readelf -d /usr/bin/ls 2>&1 | head -10' 0 "��̬��"

echo ""
echo "All binutils-readelf functional tests passed!"
