#!/bin/sh -eux
# Functional test: kmod - ��������
# Commands: lsmod, modinfo, modprobe

. "../setup.sh"

rlRun 'lsmod 2>&1 | head -10' 0 "�г����ص�ģ��"
rlRun 'modinfo --help 2>&1 | head -10' 0 "modinfo ����"
rlRun 'modprobe --help 2>&1 | head -10' 0 "modprobe ����"

. "../teardown.sh"
echo "All kmod-basic functional tests passed!"
