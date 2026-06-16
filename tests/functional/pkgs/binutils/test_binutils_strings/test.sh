#!/bin/sh -eux
# Functional test: binutils - strings
# Commands: strings

. "../setup.sh"

rlRun 'strings /usr/bin/ls 2>&1 | head -10' 0 "��ȡ ls �ַ���"
rlRun 'strings -n 8 /usr/bin/ls 2>&1 | head -10' 0 "��ȡ���ַ���"

. "../teardown.sh"
echo "All binutils-strings functional tests passed!"
