#!/bin/sh -eux
# Functional test: binutils - nm
# Commands: nm

. "../setup.sh"

rlRun 'nm /usr/bin/ls 2>&1 | head -10' 0 "�鿴 ls ���ű�"
rlRun 'nm -D /usr/bin/ls 2>&1 | head -10' 0 "�鿴��̬����"

. "../teardown.sh"
echo "All binutils-nm functional tests passed!"
