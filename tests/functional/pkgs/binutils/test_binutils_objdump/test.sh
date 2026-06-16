#!/bin/sh -eux
# Functional test: binutils - objdump
# Commands: objdump

. "../setup.sh"

rlRun 'objdump -f /usr/bin/ls 2>&1 | head -10' 0 "�鿴�ļ�ͷ"
rlRun 'objdump -h /usr/bin/ls 2>&1 | head -20' 0 "�鿴����Ϣ"
rlRun 'objdump -d /usr/bin/ls 2>&1 | head -10' 0 "�����"

. "../teardown.sh"
echo "All binutils-objdump functional tests passed!"
