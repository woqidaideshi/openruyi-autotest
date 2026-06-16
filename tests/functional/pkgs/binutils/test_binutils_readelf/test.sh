#!/bin/sh -eux
# Functional test: binutils - readelf
# Commands: readelf

. "../setup.sh"

rlRun 'readelf -h /usr/bin/ls 2>&1 | head -20' 0 "ELF ͷ"
rlRun 'readelf -S /usr/bin/ls 2>&1 | head -20' 0 "��ͷ��"
rlRun 'readelf -d /usr/bin/ls 2>&1 | head -10' 0 "��̬��"

. "../teardown.sh"
echo "All binutils-readelf functional tests passed!"
