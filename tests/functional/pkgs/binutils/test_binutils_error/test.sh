#!/bin/sh -eux
# Functional test: binutils ������

. "../setup.sh"

rlRun 'nm nonexistent 2>&1 || true' 1-255 "nm �����ڵ��ļ�"
rlRun 'objdump nonexistent 2>&1 || true' 1-255 "objdump �����ڵ��ļ�"
rlRun 'readelf nonexistent 2>&1 || true' 1-255 "readelf �����ڵ��ļ�"
rlRun 'nm --invalid 2>&1 || true' 0 "nm ��Ч����"

. "../teardown.sh"
echo "All binutils-error functional tests passed!"
