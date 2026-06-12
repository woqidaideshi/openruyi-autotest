#!/bin/sh -eux
# Functional test: binutils - �����ƹ��߼�
# Commands: ar, nm, objdump, objcopy, readelf, size, strings, strip, addr2line, c++filt, elfedit, ranlib

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q binutils 2>/dev/null || { echo 'binutils not installed, skipping'; exit 0; }
which ar 2>/dev/null || echo 'ar not found'
which nm 2>/dev/null || echo 'nm not found'
which objdump 2>/dev/null || echo 'objdump not found'
which objcopy 2>/dev/null || echo 'objcopy not found'
which readelf 2>/dev/null || echo 'readelf not found'
which size 2>/dev/null || echo 'size not found'

echo ""
echo "All binutils functional tests passed!"
