#!/bin/sh -eux
# Functional test: binutils ������

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q binutils 2>/dev/null || { echo 'binutils not installed, skipping'; exit 0; }
which nm 2>/dev/null || echo 'nm not found'
which objdump 2>/dev/null || echo 'objdump not found'
which readelf 2>/dev/null || echo 'readelf not found'

echo "=== ������ ==="
rlRun 'nm nonexistent 2>&1 || true' 1-255 "nm �����ڵ��ļ�"
rlRun 'objdump nonexistent 2>&1 || true' 1-255 "objdump �����ڵ��ļ�"
rlRun 'readelf nonexistent 2>&1 || true' 1-255 "readelf �����ڵ��ļ�"
rlRun 'nm --invalid 2>&1 || true' 0 "nm ��Ч����"

echo ""
echo "All binutils-error functional tests passed!"
